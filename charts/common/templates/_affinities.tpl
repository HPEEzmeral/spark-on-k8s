{{/* vim: set filetype=mustache: */}}

{{/*
Returns Node Affinity
Usage:
{{ include "common.nodeAffinity" . }}
*/}}
{{- define "common.nodeAffinity" -}}
preferredDuringSchedulingIgnoredDuringExecution: {{ include "common.nodeAffinity.preferred" . }}
requiredDuringSchedulingIgnoredDuringExecution: {{ include "common.nodeAffinity" . }}
{{- end }}

{{/*
Returns a preferred nodeAffinity definition

Usage:
{{ include "common.nodeAffinity.preferred" . }}
*/}}
{{- define "common.nodeAffinity.preferred" -}}
- preference:
    matchExpressions:
        - key: "hpe.com/compute"
          operator: "Exists"
  weight: 50
{{- end }}


{{/*
Return a required nodeAffinity definition

Usage:
{{ include "common.nodeAffinity.required" . }}

*/}}
{{- define "common.nodeAffinity.required" -}}
nodeSelectorTerms:
- matchExpressions:
    - key: "hpe.com/usenode"
      operator: "Exists"
    - key: "hpe.com/exclusivecluster"
      operator: "In"
      values:
        - "none"
        - {{ .Release.Namespace | quote }}
{{- end -}}

{{/*
Returns a preferred podAntiAffinity definition

Usage:
{{ include "common.podAntiAffinity.preferred" (dict "componentName" "example-name" ) }}

Params:
  - componentName - String - Required. Used to add componentName to podAntiAffinity

*/}}
{{- define "common.podAntiAffinity.preferred" -}}
- podAffinityTerm:
    labelSelector:
        matchExpressions:
            - key: "hpe.com/component"
              operator: "In"
              values:
                - {{ .componentName }}
    topologyKey: "kubernetes.io/hostname"
  weight: 1
{{- end }}
