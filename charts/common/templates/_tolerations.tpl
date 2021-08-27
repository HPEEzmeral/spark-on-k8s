{{/*
Returns Tolerations

Usage:
{{ include "common.tolerations" (dict "componentName" "example-name" "namespace" "example-ns") }}

Params:
  - componentName - String - Required. Used to add componentName to tolerations
  - namespace - String - Required. Namespace for the relase is required to add to tolerations

*/}}
{{- define "common.tolerations" -}}
- key: hpe.com/compute-{{ .namespace }}
  operator: Exists
- key: hpe.com/{{ .componentName }}-{{ .namespace }}
  operator: Exists
{{- end }}
