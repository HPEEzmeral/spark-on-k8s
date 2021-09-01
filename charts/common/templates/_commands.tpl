{{/*
Returns standard Args
Usage:
{{ include "common.args" . }}
*/}}
{{- define "common.args" -}}
- "/bin/bash"
- "-c"
- "/opt/mapr/kubernetes/start.sh"
{{- end }}

{{/*
Returns standard commands
Usage:
{{ include "common.commands" . }}
*/}}
{{- define "common.commands" -}}
- "/tini"
- "--"
{{- end }}
