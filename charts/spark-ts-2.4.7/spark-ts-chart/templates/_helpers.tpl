{{/*
Expand the name of the chart.
*/}}
{{- define "spark-ts-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark-ts-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark-ts-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "spark-ts-chart.selectorLabels" -}}
hpe.com/component: {{ .Chart.Name }}
{{- end }}

{{/*
labels
usage:
{{ include "spark-ts-chart.labels" (dict "componentName" "FOO" "context" $) -}}
*/}}
{{- define "spark-ts-chart.labels" -}}
hpe.com/component: {{ .componentName }}
hpe.com/tenant: {{ .context.Release.Namespace }}
{{- range $label := .context.Values.labels }}
hpe.com/{{ $label.name }}: {{ $label.value }}
{{- end }}
{{- end }}


{{/*
    Node Affinity
*/}}
{{- define "spark-ts-chart.nodeAffinity" -}}
preferredDuringSchedulingIgnoredDuringExecution: {{ include "spark-ts-chart.nodeAffinity.preferred" . }}
requiredDuringSchedulingIgnoredDuringExecution: {{ include "spark-ts-chart.nodeAffinity" . }}
{{- end }}

{{/*
Return a preferred nodeAffinity definition
*/}}
{{- define "spark-ts-chart.nodeAffinity.preferred" -}}
- preference:
    matchExpressions:
        - key: {{ .Values.nodeAfinityConfigs.storageNode.key  | quote }}
          operator: {{ .Values.nodeAfinityConfigs.storageNode.operator  | quote }}
  weight: 50
{{- end }}


{{/*
Return a required nodeAffinity definition
*/}}
{{- define "spark-ts-chart.nodeAffinity.required" -}}
nodeSelectorTerms:
- matchExpressions:
    - key: {{ .Values.nodeAfinityConfigs.maprNode.key | quote}}
      operator: {{ .Values.nodeAfinityConfigs.maprNode.operator  | quote }}
    - key: {{ .Values.nodeAfinityConfigs.exclusiveCluster.key  | quote }}
      operator: "In"
      values:
        - "none"
        - {{ .Release.Namespace | quote }}
{{- end -}}

{{/*
Return a preferred podAffinity definition
*/}}
{{- define "spark-ts-chart.podAntiAffinity.preferred" -}}
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
{{- define "spark-ts-chart.probe.liveness" -}}
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
{{- define "spark-ts-chart.probe.readiness" -}}
exec:
    command:
        - {{ .Values.readinessProbe.path }}
failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
successThreshold: {{ .Values.readinessProbe.successThreshold }}
timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
{{- end }}


{{/*
Return a lifecycle
*/}}
{{- define "spark-ts-chart.probe.lifecycle" -}}
preStop:
    exec:
        command:
            - "sh"
            - {{ .Values.lifecycle.preStop.path }}
{{- end }}

{{/*
Return HttpPortSparktsUI
*/}}
{{- define "spark-ts-chart.getHttpPortSparkTsUI" -}}
{{- $httpPortSparktsUI := .Values.ports.httpPort -}}
{{- if(not .Values.tenantIsUnsecure)  -}}
{{- $httpPortSparktsUI = .Values.ports.httpsPort -}}
{{- end -}}
{{ print $httpPortSparktsUI }}
{{- end -}}


{{/*
Return ports
*/}}
{{- define "spark-ts-chart.ports" -}}
- name: "http"
  protocol: "TCP"
  containerPort: {{ include "spark-ts-chart.getHttpPortSparkTsUI" . }}
- name: "ssh"
  protocol: "TCP"
  hostPort: {{ .Values.ports.sshHostPort }}
  containerPort: {{ .Values.ports.sshPort }}
{{- end }}


{{/*
Return SecurityContext
*/}}
{{- define "spark-ts-chart.securityContext" -}}
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
{{- define "spark-ts-chart.tolerations" -}}
- key: hpe.com/compute-{{ .Release.Namespace }}
  operator: Exists
- key: hpe.com/{{ .Chart.Name }}-{{ .Release.Namespace }}
  operator: Exists
{{- end }}

{{/*
return service account name
*/}}
{{- define "spark-ts-chart.serviceAccountName" -}}
{{- if empty .Values.serviceAccount.name -}}
    {{ include "spark-ts-chart.name" . }}-sa
{{- else -}}
    {{ .Values.serviceAccount.name }}
{{- end -}}
{{- end }}


{{/*
return env for containers
*/}}
{{- define "spark-ts-chart.env" -}}
{{- tpl (.Values.conatinerConfigs.env | toYaml) . }}
- name: CLUSTER_CREATE_TIME
  value: {{ now | date "20060102150405" | quote }}
{{- if .Values.hiveSiteSource }}
- name: HIVE_SITE_CM_NAME
  value: {{ .Values.hiveSiteSource }}
{{- end }}
{{- end }}
