{{/*
Expand the name of the chart.
*/}}
{{- define "autoticket-generator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
return namespace where the autoticket generator must be deployed
*/}}
{{- define "autoticket-generator.namespace" -}}
{{- default "hpe-system" .Values.namespace | trunc 63 | trimSuffix "-" }}
{{- end}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "autoticket-generator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a autoticket generator name with prefix hpe
*/}}
{{- define "autoticket-generator.hpePrefix" -}}
{{- printf "%s-%s" "hpe" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "autoticket-generator.selectorLabels" -}}
app: autoticket-generator-app
{{- end }}

{{/*Create a tenant validator post install hook name
*/}}
{{- define "autoticket-generator.postInstallHookName" -}}
{{- printf "%s-%s" .Values.name "postinstall-hook" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant validator pre delete hook name
*/}}
{{- define "autoticket-generator.preDeleteHookName" -}}
{{- printf "%s-%s" .Values.name "predelete-hook" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a autoticket generator service name
*/}}
{{- define "autoticket-generator.svcName" -}}
{{- printf "%s-%s" .Values.name "svc" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
return tolerations for autoticket generator components
*/}}
{{- define "autoticket-generator.tolerations" -}}
- key: node-role.kubernetes.io/master
  operator: Exists
{{- end }}

{{/*
return podAntiAffinity for autoticket generator components
*/}}
{{- define "autoticket-generator.podAntiAffinity.preferred" -}}
- podAffinityTerm:
    labelSelector:
        matchExpressions:
            - key: "app"
              operator: "In"
              values:
                - tenantoperator
    topologyKey: "kubernetes.io/hostname"
  weight: 1
{{- end }}

{{/*
return env for autoticket-generator container
*/}}
{{- define "autoticket-generator.env" -}}
- name : LOG_LEVEL
  value: "info"
{{- end }}

{{/*
return volume for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumes" -}}
- name: autoticket-generator-certs
  secret:
    secretName: autoticket-generator-certs
{{- end }}

{{/*
return volumeMounts for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumesMounts" -}}
- name: autoticket-generator-certs
  mountPath:  /opt/validator/certs
  readOnly: true
{{- end }}