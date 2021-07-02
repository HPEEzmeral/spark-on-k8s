{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "spark-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Version of spark
*/}}
{{- define "spark-operator.sparkversion" -}}
{{- default "2.4.7" .Values.sparkVersionOverride -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark-operator.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
labels
*/}}
{{- define "spark-operator.labels" -}}
app.kubernetes.io/name: {{ include "spark-operator.name" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}

{{/*
spark namespace
*/}}
{{- define "spark-operator.sparknamespace" -}}
{{- if ne .Release.Namespace "default" -}}
    {{ .Release.Namespace }}
{{- else -}}
    {{ include "spark-operator.fullname" . }}-ns
{{- end -}}
{{- end }}


{{/*
cluster role
*/}}
{{- define "spark-operator.clusterrole" -}}
{{ include "spark-operator.fullname" . }}-CR
{{- end }}

{{/*
cluster role binding
*/}}
{{- define "spark-operator.clusterrolebinding" -}}
{{ include "spark-operator.fullname" . }}-CRB
{{- end }}


