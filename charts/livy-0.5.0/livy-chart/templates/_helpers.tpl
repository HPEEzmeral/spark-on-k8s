{{/*
Expand the name of the chart.
*/}}
{{- define "livy-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "livy-chart.fullname" -}}
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
{{- define "livy-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "livy-chart.labels" -}}
helm.sh/chart: {{ include "livy-chart.chart" . }}
{{ include "livy-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "livy-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "livy-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return ports
*/}}
{{- define "livy-chart.ports" -}}
- containerPort: {{ .Values.ports.livyHttpPort }}
  name: http
  protocol: TCP
{{- range $i, $e := untilStep ( int .Values.ports.livyInternalPortStart ) ( add1 .Values.ports.livyInternalPortEnd | int ) 1 }}
- containerPort: {{ $e }}
  name: internal-{{ $e }}
  protocol: TCP
{{- end }}
- name: ssh
  containerPort: {{ .Values.ports.sshPort }}
  hostPort: {{ .Values.ports.sshHostPort }}
  protocol: TCP
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "livy-chart.serviceAccountName" -}}
{{- if ( and ( not .Values.serviceAccount.create )  ( not ( empty .Values.serviceAccount.name)) )  -}}
    {{- .Values.serviceAccount.name }}
{{- else -}}
    hpe-{{ .Release.Namespace }}
{{- end -}}
{{- end }}

{{/*
Create the name of the configmap
*/}}
{{- define "livy-chart.configmapName" -}}
{{ printf "%s-cm" .Chart.Name  }}
{{- end }}

{{/*
Returns the name for livy http service
*/}}
{{- define "livy-chart.httpServiceName" -}}
livy-http
{{- end }}


{{/*
Returns the name for livy internal service
*/}}
{{- define "livy-chart.internalServiceName" -}}
livy-internal
{{- end }}

{{/*
Returns the name for livy Role
*/}}
{{- define "livy-chart.roleName" -}}
{{ printf "%s-role" .Chart.Name }}
{{- end }}

{{/*
Returns the name for livy RoleBinding
*/}}
{{- define "livy-chart.roleBindingName" -}}
{{ printf "%s-role-binding" .Chart.Name }}
{{- end }}

{{/*
Returns the full DeImage
*/}}
{{- define "livy-chart.fullDeImage" -}}
{{- if not .Values.deImage }}
{{ .Values.image.baseRepository }}/spark-2.4.7:202106291513C
{{- else -}}
{{ .Values.image.baseRepository }}/{{ .Values.deImage }}
{{- end }}
{{- end }}

{{/*
return env for containers
*/}}
{{- define "livy-chart.env" -}}
{{ include "common.defaultEnv" (dict "containerName" .Chart.Name) }}
{{- if .Values.hiveSiteSource }}
- name: LIVY_HIVESITE_SOURCE
  value: {{ .Values.hiveSiteSource }}
- name: SSH_PORT
  value: {{ .Values.ports.sshHostPort | quote }}
{{- end }}
{{- end }}

{{/*
return volume mounts for containers
*/}}
{{- define "livy-chart.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
{{- if not .Values.tenantIsUnsecure }}
{{ include "common.security.volumeMounts" . }}
{{- end }}
{{- if eq .Values.sessionRecovery.kind "pvc" }}
- name: livy-sessionstore
  mountPath: "/opt/mapr/livy/livy-{{ .Chart.AppVersion }}/session-store"
{{- end }}
- name: logs
  mountPath: /opt/mapr/livy/livy-{{ .Chart.AppVersion }}/logs
{{- end }}

{{/*
returns volumes for deployment
*/}}
{{- define "livy-chart.volumes" -}}
{{ include "common.volumes" (dict "configmapName" ( include "livy-chart.configmapName" . )  "componentName" .Chart.Name ) }}
{{- if not .Values.tenantIsUnsecure }}
{{ include "common.security.volumes" . }}
{{- end }}
{{- if and  ( eq .Values.sessionRecovery.kind "pvc" ) ( .Values.sessionRecovery.pvcName ) }}
- name: livy-sessionstore
  persistentVolumeClaim:
    claimName: {{ .Values.sessionRecovery.pvcName }}
{{- end }}
{{- end }}
