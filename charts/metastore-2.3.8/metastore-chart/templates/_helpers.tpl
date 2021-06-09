{{/*
Expand the name of the chart.
*/}}
{{- define "metastore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "metastore.fullname" -}}
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
{{- define "metastore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "metastore.labels" -}}
helm.sh/chart: {{ include "metastore.chart" . }}
{{ include "metastore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "metastore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "metastore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "metastore.serviceAccountName" -}}
{{- if .Values.serviceAccounts.metastore.create }}
{{- default (include "metastore.fullname" .) .Values.serviceAccounts.metastore.name }}
{{- else }}
{{- default "default" .Values.serviceAccounts.metastore.name }}
{{- end }}
{{- end }}

{{- define "metastore.sparkServiceAccountName" -}}
{{- if .Values.serviceAccounts.spark.create }}
{{- default (printf "%s-spark" (include "metastore.fullname" .)) .Values.serviceAccounts.spark.name }}
{{- else }}
{{- default "default" .Values.serviceAccounts.spark.name }}
{{- end }}
{{- end }}