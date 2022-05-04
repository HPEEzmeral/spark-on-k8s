{{/*
Expand the name of the chart.
*/}}
{{- define "spark-client-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark-client-chart.fullname" -}}
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
{{- define "spark-client-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spark-client-chart.labels" -}}
helm.sh/chart: {{ include "spark-client-chart.chart" . }}
{{ include "spark-client-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark-client-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spark-client-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "spark-client-chart.serviceAccountName" -}}
{{- if ( and ( not .Values.serviceAccount.create ) ( not ( empty .Values.serviceAccount.name)) ) -}}
    {{- .Values.serviceAccount.name }}
{{- else -}}
    hpe-{{ .Release.Namespace }}
{{- end -}}
{{- end }}


{{/*
Create imagepullsecrets
*/}}
{{- define "spark-client-chart.imagepullSecrets" -}}
  {{- if empty .Values.imagePullSecrets -}}
    {{ printf "- name: %s" ( .Values.defaultPullSecret ) | nindent 8 }}
  {{- else -}}
    {{- toYaml .Values.imagePullSecrets | nindent 8 }}
  {{- end -}}
{{- end -}}

{{/*
Volume mounts for containers
*/}}
{{- define "spark-client.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
{{ if .Values.datafabric.fullIntegrationEnabled }}
    {{- include "common.security.volumeMounts" . }}
{{- end -}}
{{- end }}
