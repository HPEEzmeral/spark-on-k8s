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
    claimName: {{ .Values.eventlogstorage.pvcname }}
{{- end }}

{{/*
  returns pvc volumeMount
*/}}
{{- define "spark-hs-chart.pvcVolumeMount" }}
- mountPath: /opt/mapr/spark/{{- .Values.sparkVersion -}}/logs/sparkhs-eventlog-storage
  name: sparkhs-eventlog-storage
{{- end }}

{{/*
  returns eventLogPath
*/}}
{{- define "spark-hs-chart.eventLogPath" -}}
{{- if ( eq .Values.eventlogstorage.kind "pvc") -}}
file:///opt/mapr/spark/{{- .Values.sparkVersion -}}/logs/sparkhs-eventlog-storage
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
{{- if eq .Values.eventlogstorage.kind "s3"  }}
- name: spark-hs-s3-secret
  mountPath: "/opt/mapr/kubernetes/s3-secrets"
  readOnly: true
{{- end }}
{{- end }}

{{/*
    returns volumes
*/}}
{{- define "spark-hs-chart.volumes" -}}
{{ include "common.volumes" (dict "configmapName" ( include "spark-hs-chart.conifgmapName" . ) "componentName" ( include "spark-hs-chart.deploymentName" . )) }}
{{- if ( eq .Values.eventlogstorage.kind "pvc") }}
{{ include "spark-hs-chart.pvcVolume" . }}
{{- end }}
{{- if not .Values.tenantIsUnsecure }}
{{ include "common.security.volumes" . }}
{{- end }}
{{- if eq .Values.eventlogstorage.kind "s3"  }}
- name: spark-hs-s3-secret
  secret:
    secretName: spark-hs-s3-secret
{{- end }}
{{- end }}

{{/*
Returns a PVC name
*/}}
{{- define "spark-hs-chart.pvcName" -}}
{{- if .Values.eventlogstorage.pvcname -}}
{{ .Values.eventlogstorage.pvcname }}
{{- else -}}
{{ printf "%s-pvc" .Release.Name }}
{{- end -}}
{{- end }}

{{/*
Returns a PV name
*/}}
{{- define "spark-hs-chart.pvName" -}}
{{ printf "%s-pv"  .Release.Name }}
{{- end }}

{{/*
Returns deployment name
*/}}
{{- define "spark-hs-chart.deploymentName" -}}
{{ .Chart.Name }}
{{- end }}

{{/*
Returns configmap name
*/}}
{{- define "spark-hs-chart.conifgmapName" -}}
{{ .Chart.Name }}-cm
{{- end }}

{{/*
Returns service name
*/}}
{{- define "spark-hs-chart.serviceName" -}}
{{ .Chart.Name }}-svc
{{- end }}

{{/*
Returns Role name
*/}}
{{- define "spark-hs-chart.roleName" -}}
{{ .Chart.Name }}-role
{{- end }}

{{/*
Returns role binding name
*/}}
{{- define "spark-hs-chart.roleBindingName" -}}
{{ .Chart.Name }}-role-binding
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
