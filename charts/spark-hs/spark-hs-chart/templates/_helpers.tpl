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
Return ports
*/}}
{{- define "spark-hs-chart.ports" -}}
{{-  if  or  ( not .Values.tenantIsUnsecure) (.Values.useCustomSSL)  }}
- name: "https"
  containerPort: {{ .Values.ports.httpsPort }}
  protocol: TCP
{{ else }}
- name: "http"
  containerPort: {{ .Values.ports.httpPort }}
  protocol: TCP
{{- end }}
- name: "ssh"
  protocol: "TCP"
  containerPort: {{ .Values.ports.sshPort }}
{{- end }}

{{/*
Return pvcVolume
*/}}
{{- define "spark-hs-chart.pvcVolume" -}}
- name: sparkhs-eventlog-storage
  persistentVolumeClaim:
    claimName: {{  include "spark-hs-chart.pvcName" . }}
{{- end }}

{{/*
  returns pvc volumeMount
*/}}
{{- define "spark-hs-chart.pvcVolumeMount" }}
- mountPath: /var/log/sparkhs-eventlog-storage
  name: sparkhs-eventlog-storage
{{- end }}

{{/*
  returns eventLogPath
*/}}
{{- define "spark-hs-chart.eventLogPath" -}}
{{- if ( eq .Values.eventlogstorage.kind "pvc") -}}
file:///var/log/sparkhs-eventlog-storage
{{- else if ( eq .Values.eventlogstorage.kind "s3") -}}
{{ .Values.eventlogstorage.s3path }}
{{- else -}}
maprfs:///apps/spark/{{ .Release.Namespace }}
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

{{/*
return volume mounts for containers
*/}}
{{- define "spark-hs-chart.volumeMounts" -}}
{{ include "common.volumeMounts" . }}
- name: logs
  mountPath: "/opt/mapr/spark/{{ .Values.sparkVersion }}/logs"
{{- end }}

{{/*
Returns a PVC name
*/}}
{{- define "spark-hs-chart.pvcName" -}}
{{- if .Values.eventlogstorage.pvcName -}}
    {{ .Values.eventlogstorage.pvcName }}
{{- else -}}
    {{ printf "%s-pvc" .Release.Name }}
{{- end -}}
{{- end }}

{{/*
Returns a PV name
*/}}
{{- define "spark-hs-chart.pvName" -}}
    {{ printf "%s-pv" .Release.Name }}
{{- end }}

{{/*
Returns a list of extra spark conf items
*/}}
{{- define "spark-hs-chart.extraConfigs" -}}
    {{ .Values.sparkExtraConfigs }}
    {{- if not (empty .Values.eventlogstorage.s3AccessKey) }}
    {{ printf "spark.hadoop.fs.s3a.access.key %s" .Values.eventlogstorage.s3AccessKey | nindent 0 }}
    {{- end }}
    {{- if not (empty .Values.eventlogstorage.s3SecretKey) }}
    {{ printf "spark.hadoop.fs.s3a.secret.key %s" .Values.eventlogstorage.s3SecretKey | nindent 0 }}
    {{- end }}
    {{ println }}
{{- end }}
