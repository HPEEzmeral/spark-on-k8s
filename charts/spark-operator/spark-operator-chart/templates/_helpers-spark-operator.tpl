{{/* vim: set filetype=mustache: */}}

{{/*
    Expand the name of the chart.
  */}}
{{- define "spark-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
    Common labels
  */}}
{{- define "spark-operator.labels" -}}
helm.sh/chart: {{ include "spark-operator.chart" . }}
{{ include "spark-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
    Selector labels
  */}}
{{- define "spark-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spark-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
    Create the name of the service account to be used by the operator
  */}}
{{- define "spark-operator.serviceAccountName" -}}
{{- if .Values.serviceAccounts.sparkoperator.create -}}
{{ default (include "spark-operator.fullname" .) .Values.serviceAccounts.sparkoperator.name }}
{{- else -}}
{{ default "default" .Values.serviceAccounts.sparkoperator.name }}
{{- end -}}
{{- end -}}

{{/*
    Create the name of the webhook Init pod
  */}}
{{- define "spark-operator.webhookInitName" -}}
    {{- printf "%s-webhook-init" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Create the name of the webhook
  */}}
{{- define "spark-operator.webhookName" -}}
    {{- printf "%s-webhook" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Create the name of the webhook config
  */}}
{{- define "spark-operator.webhookConfigName" -}}
    {{- printf "%s-webhook-config" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Create the name of the webhook cleanup pod
  */}}
{{- define "spark-operator.webhookCleanUpName" -}}
    {{- printf "%s-webhook-cleanup" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Spark Images ConfigMap section
  */}}
{{- define "spark-images.configmapName" -}}
{{- printf "spark-images-cm" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "spark-images.labels" -}}
{{ include "spark-operator.labels" . }}
{{- end }}
