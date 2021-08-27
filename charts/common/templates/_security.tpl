{{/*
Returns SecurityContext
*/}}
{{- define "common.securityContext" -}}
capabilities:
    add:
     - SYS_NICE
     - SYS_RESOURCE
runAsGroup: 5000
runAsUser: 5000
{{- end }}