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
return service account name
*/}}
{{- define "spark-ts-chart.serviceAccountName" -}}
{{- if ( and ( not .Values.serviceAccount.create )  ( not ( empty .Values.serviceAccount.name)) )  -}}
    {{ .Values.serviceAccount.name }}
{{- else -}}
    hpe-{{ .Release.Namespace }}
{{- end -}}
{{- end }}

{{/*
return env for containers
*/}}
{{- define "spark-ts-chart.env" -}}
{{ include "common.defaultEnv" (dict "containerName" .Chart.Name) }}
- name: SSH_PORT
  value: {{ .Values.ports.sshHostPort | quote }}
{{- if .Values.hiveSiteSource }}
- name: HIVE_SITE_CM_NAME
  value: {{ .Values.hiveSiteSource }}
{{- end }}
{{- end }}

{/*
return volume mounts for containers
*/}}
{{- define "spark-ts-chart.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
- name: logs
  mountPath: "/opt/mapr/spark/spark-{{ .Values.sparkVersion }}/logs"
{{- end }}
