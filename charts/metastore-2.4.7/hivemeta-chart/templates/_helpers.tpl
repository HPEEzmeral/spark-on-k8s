{{/*
Expand the name of the chart.
*/}}
{{- define "hivemeta-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hivemeta-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hivemeta-chart.labels" -}}
hpe.com/component: {{ .componentName }}
hpe.com/tenant: {{ .context.Release.Namespace }}
{{- range $label := .context.Values.labels }}
hpe.com/{{ $label.name }}: {{ $label.value }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hivemeta-chart.selectorLabels" -}}
hpe.com/component: {{ .Chart.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hivemeta-chart.serviceAccountName" -}}
{{- if ( and ( not .Values.serviceAccount.create )  ( not ( empty .Values.serviceAccount.name)) )  -}}
    {{ .Values.serviceAccount.name }}
{{- else -}}
    hpe-{{ .Release.Namespace }}
{{- end -}}
{{- end }}


{{/*
Return SecurityContext
*/}}
{{- define "hivemeta-chart.securityContext" -}}
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
{{- define "hivemeta-chart.tolerations" -}}
- key: hpe.com/compute-{{ .Release.Namespace }}
  operator: Exists
- key: hpe.com/{{ .Chart.Name }}-{{ .Release.Namespace }}
  operator: Exists
{{- end }}

{{/*
Return a liveness probe
*/}}
{{- define "hivemeta-chart.probe.liveness" -}}
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
{{- define "hivemeta-chart.probe.readiness" -}}
exec:
    command:
        - {{ .Values.readinessProbe.path }}
failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
successThreshold: {{ .Values.readinessProbe.successThreshold }}
timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
{{- end }}


{{/*
    Node Affinity
*/}}
{{- define "hivemeta-chart.nodeAffinity" -}}
preferredDuringSchedulingIgnoredDuringExecution: {{ include "hivemeta-chart.nodeAffinity.preferred" . }}
requiredDuringSchedulingIgnoredDuringExecution: {{ include "hivemeta-chart.nodeAffinity" . }}
{{- end }}

{{/*
Return a preferred nodeAffinity definition
*/}}
{{- define "hivemeta-chart.nodeAffinity.preferred" -}}
- preference:
    matchExpressions:
        - key: {{ .Values.nodeAfinityConfigs.storageNode.key  | quote }}
          operator: {{ .Values.nodeAfinityConfigs.storageNode.operator  | quote }}
  weight: 50
{{- end }}

{{/*
Return a required nodeAffinity definition
*/}}
{{- define "hivemeta-chart.nodeAffinity.required" -}}
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
{{- define "hivemeta-chart.podAntiAffinity.preferred" -}}
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
Return QueryPort
*/}}
{{- define "hivemeta-chart.getQeryPort" -}}
{{- $queryPort := .Values.ports.queryPort -}}
{{ print $queryPort }}
{{- end -}}


{{/*
Return ports
*/}}
{{- define "hivemeta-chart.ports" -}}
- name: "query"
  protocol: "TCP"
  containerPort: {{ include "hivemeta-chart.getQeryPort" . }}
- name: "ssh"
  protocol: "TCP"
  hostPort: {{ .Values.ports.sshHostPort }}
  containerPort: {{ .Values.ports.sshPort }}
{{- end }}

{/*
return env for containers
*/}}
{{- define "hivemeta-chart.env" -}}
{{ include "common.defaultEnv" (dict "containerName" .Chart.Name) }}
- name: SSH_PORT
  value: {{ .Values.ports.sshHostPort | quote }}
- name: HIVE_USE_DB
  valueFrom:
    configMapKeyRef:
      key: HIVE_USE_DB
      name: cluster-cm
- name: HIVE_DB_LOCATION
  valueFrom:
    configMapKeyRef:
      key: HIVE_DB_LOCATION
      name: cluster-cm
{{- end }}

{/*
return volume mounts for containers
*/}}
{{- define "hivemeta-chart.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
- name: logs
  mountPath: "/opt/mapr/hive/hive-{{ .Chart.AppVersion }}/logs"
{{- end }}
