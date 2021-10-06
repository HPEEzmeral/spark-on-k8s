{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "spark-hs-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark-hs-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark-hs-chart.selectorLabels" -}}
hpe.com/component: {{ .Chart.Name }}
{{- end }}

{{/*
labels
usage:
{{ include "spark-hs-chart.labels" (dict "componentName" "FOO" "context" $) -}}
*/}}
{{- define "spark-hs-chart.labels" -}}
hpe.com/component: {{ .componentName }}
hpe.com/tenant: {{ .context.Values.tenantNameSpace }}
{{- range $label := .context.Values.labels }}
hpe.com/{{ $label.name }}: {{ $label.value }}
{{- end }}
{{- end }}


{{/*
    Node Affinity
*/}}
{{- define "spark-hs-chart.nodeAffinity" -}}
preferredDuringSchedulingIgnoredDuringExecution: {{ include "spark-hs-chart.nodeAffinity.preferred" . }}
requiredDuringSchedulingIgnoredDuringExecution: {{ include "spark-hs-chart.nodeAffinity" . }}
{{- end }}

{{/*
Return a preferred nodeAffinity definition
*/}}
{{- define "spark-hs-chart.nodeAffinity.preferred" -}}
- preference:
    matchExpressions:
        - key: {{ .Values.nodeAfinityConfigs.storageNode.key  | quote }}
          operator: {{ .Values.nodeAfinityConfigs.storageNode.operator  | quote }}
  weight: 50
{{- end }}


{{/*
Return a required nodeAffinity definition
*/}}
{{- define "spark-hs-chart.nodeAffinity.required" -}}
nodeSelectorTerms:
- matchExpressions:
    - key: {{ .Values.nodeAfinityConfigs.maprNode.key | quote}}
      operator: {{ .Values.nodeAfinityConfigs.maprNode.operator  | quote }}
    - key: {{ .Values.nodeAfinityConfigs.exclusiveCluster.key  | quote }}
      operator: "In"
      values:
        - "none"
        - {{ .Values.tenantNameSpace | quote }}
{{- end -}}

{{/*
Return a preferred podAffinity definition
*/}}
{{- define "spark-hs-chart.podAntiAffinity.preferred" -}}
- podAffinityTerm:
    labelSelector:
        matchExpressions:
            - key: {{ .Values.podAfinityConfigs.componentKey  | quote }}
              operator: "In"
              values:
                - {{ .Chart.Name | quote }}
    topologyKey: {{ .Values.podAfinityConfigs.topologyKey | quote}}
  weight: 1
{{- end }}

{{/*
Return a liveness probe
*/}}
{{- define "spark-hs-chart.probe.liveness" -}}
exec:
    command:
        - {{ .Values.livenessProbe.path }}
initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
failureThreshold: {{ .Values.livenessProbe.failureThreshold }}
periodSeconds: {{ .Values.livenessProbe.periodSeconds }}
successThreshold: {{ .Values.livenessProbe.successThreshold }}
timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds }}
{{- end }}

{{/*
Return a readiness probe
*/}}
{{- define "spark-hs-chart.probe.readiness" -}}
exec:
    command:
        - {{ .Values.readinessProbe.path }}
failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
successThreshold: {{ .Values.readinessProbe.successThreshold }}
timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
{{- end }}

{{/*
Return HttpPortSparkHsUI
*/}}
{{- define "spark-hs-chart.getHttpPortSparkHsUI" -}}
{{- $httpPortSparkHsUI := .Values.ports.httpPort -}}
{{- if(not .Values.tenantIsUnsecure)  -}}
{{- $httpPortSparkHsUI = .Values.ports.httpsPort -}}
{{- end -}}
{{ print $httpPortSparkHsUI }}
{{- end -}}


{{/*
Return ports
*/}}
{{- define "spark-hs-chart.ports" -}}
- name: "http"
  protocol: "TCP"
  containerPort: {{ include "spark-hs-chart.getHttpPortSparkHsUI" . }}
- name: "ssh"
  protocol: "TCP"
  containerPort: {{ .Values.ports.sshPort }}
{{- end }}


{{/*
Return SecurityContext
*/}}
{{- define "spark-hs-chart.securityContext" -}}
capabilities:
    add:
     - SYS_NICE
     - SYS_RESOURCE
runAsGroup: 5000
runAsUser: 5000
{{- end }}

{{/*
Return Tolerations
*/}}
{{- define "spark-hs-chart.tolerations" -}}
- key: hpe.com/compute-{{ .Values.tenantNameSpace }}
  operator: Exists
- key: hpe.com/{{ .Chart.Name }}-{{ .Values.tenantNameSpace }}
  operator: Exists
{{- end }}

{{/*
Return pvcVolume
*/}}
{{- define "spark-hs-chart.pvcVolume" -}}
- name: sparkhs-eventlog-storage
  persistentVolumeClaim:
    claimName: {{ .Values.eventlogstorage.pvcname }}
{{- end }}

{{/*
  returns pvc volumeMount
*/}}
{{- define "spark-hs-chart.pvcVolumeMount" }}
- mountPath: /opt/mapr/spark/{{- .Values.sparkVersion -}}/logs/sparkhs-eventlog-storage
  name: sparkhs-eventlog-storage
{{- end }}

{{/*
  returns eventLogPath
*/}}
{{- define "spark-hs-chart.eventLogPath" -}}
{{- if ( eq .Values.eventlogstorage.kind "pvc") -}}
file:///opt/mapr/spark/{{- .Values.sparkVersion -}}/logs/sparkhs-eventlog-storage
{{- else if ( eq .Values.eventlogstorage.kind "s3") -}}
s3a://apps/spark/{{ .Release.Namespace }}
{{- else -}}
maprfs:///apps/spark/{{ .Values.tenantNameSpace }}
{{- end -}}
{{- end -}}

{{/*
return service account name
*/}}
{{- define "spark-hs-chart.serviceAccountName" -}}
{{- if ( and ( not .Values.serviceAccount.create )  ( not ( empty .Values.serviceAccount.name)) )  -}}
    {{ .Values.serviceAccount.name }}
{{- else -}}
    hpe-{{ .Release.Namespace }}
{{- end -}}
{{- end }}

{{/*
return env for containers
*/}}
{{- define "spark-hs-chart.env" -}}
{{ include "common.defaultEnv" (dict "containerName" .Chart.Name) }}
{{- end }}

{/*
return volume mounts for containers
*/}}
{{- define "spark-hs-chart.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
- name: logs
  mountPath: "/opt/mapr/spark/spark-{{ .Values.sparkVersion }}/logs"
{{- end }}
