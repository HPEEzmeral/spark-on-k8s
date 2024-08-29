{{/* vim: set filetype=mustache: */}}

{{/*
    Create the name of the service account to be used by spark apps
  */}}
{{- define "spark.serviceAccountName" -}}
{{- if .Values.serviceAccounts.spark.create -}}
{{- $sparkServiceaccount := printf "%s-%s" .Release.Name "spark" -}}
    {{ default $sparkServiceaccount .Values.serviceAccounts.spark.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.spark.name }}
{{- end -}}
{{- end -}}
