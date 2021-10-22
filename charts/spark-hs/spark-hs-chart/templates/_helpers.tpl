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
Return pvcVolume
*/}}
{{- define "spark-hs-chart.pvcVolume" -}}
- name: sparkhs-eventlog-storage
  persistentVolumeClaim:
    claimName: {{ .Values.eventlogstorage.pvcName }}
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
