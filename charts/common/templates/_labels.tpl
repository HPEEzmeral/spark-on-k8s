{{/*
Retruns labels

Usage:
{{ include "common.labels" (dict "componentName" "example-name" "namespace" "example-ns") }}

Params:
  - componentName - String - Required. Used to add componentName to labels
  - namespace - String - Required. Namespace for the relase is required to add to labels

*/}}
{{- define "common.labels" -}}
hpe.com/cluster: dataplatform
hpe.com/namespacetype: Tenant
hpe.com/component: {{ .componentName }}
hpe.com/tenant: {{ .namespace }}
hpe.com/version: 6.2.0
{{- end }}



{{/*
returns selector labels

Usage:
{{ include "common.selectorLabels" (dict "componentName" "example-name") }}

Params:
  - componentName - String - Required. Used to add componentName to selector labels

*/}}
{{- define "common.selectorLabels" -}}
hpe.com/component: {{ .componentName }}
{{- end }}