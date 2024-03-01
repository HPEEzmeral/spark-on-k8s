{{/* vim: set filetype=mustache: */}}

{{/*
Auto ticket generator name
*/}}
{{- define "autoticket-generator.name" -}}
{{- default "autoticket-generator" .Values.autotix.autotixName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator name with prefix hpe
*/}}
{{- define "autoticket-generator.hpePrefix" -}}
{{- printf "%s-%s" "hpe" .Values.autotix.autotixName  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels for autoticket generator
*/}}
{{- define "autoticket-generator.selectorLabels" -}}
app: autoticket-generator-app
{{- end }}

{{/*
Create the name of the service account to be used by autoticket generator
*/}}
{{- define "autoticket-generator.serviceAccountName" -}}
{{- if .Values.serviceAccounts.autotix.create -}}
{{- printf "%s-%s" "hpe" "autoticket-generator" | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{ default "default" .Values.serviceAccounts.autotix.name }}
{{- end -}}
{{- end -}}

{{/*
Create a autoticket generator configmap name
*/}}
{{- define "autoticket-generator.configMapName" -}}
{{- printf "%s-%s" .Values.autotix.autotixName "cm"  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator service name
*/}}
{{- define "autoticket-generator.svcName" -}}
{{- printf "%s-%s" .Values.autotix.autotixName "svc" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return podAntiAffinity for autoticket generator components
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
Return env for autoticket-generator container
*/}}
{{- define "autoticket-generator.env" -}}
- name : LOG_LEVEL
  value: "info"
{{ if not (kindIs "invalid" .Values.autotix.auditLoggingEnable) }}
- name : AUDIT_LOGS_ENABLED
  value: "{{ .Values.autotix.auditLoggingEnable }}"
{{- end -}}
{{ if not (kindIs "invalid" .Values.autotix.auditLoggingURL) }}
- name : AUDITING_URL_PREFIX
  value: "{{ .Values.autotix.auditLoggingURL }}"
{{- end -}}
{{ if not (kindIs "invalid" .Values.autotix.configureLabel) }}
- name : spark-app-configure-label
  value: "{{ .Values.autotix.configureLabel }}"
{{- end -}}
{{ if not (kindIs "invalid" .Values.autotix.autoSetSparkUserNameEnvs) }}
- name: SET_SPARK_USERNAME
  value: "{{ .Values.autotix.autoSetSparkUserNameEnvs }}"
{{- end -}}
{{- end }}

{{/*
Return volume for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumes" -}}
- name: autoticket-generator-certs
  secret:
    secretName: autoticket-generator-certs
- name: autoticket-generator-cm
  configMap:
    name: {{ include "autoticket-generator.configMapName" . }}
{{- end }}

{{/*
Return volumeMounts for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumesMounts" -}}
- name: autoticket-generator-certs
  mountPath:  /opt/validator/certs
  readOnly: true
- name: autoticket-generator-cm
  mountPath:  /opt/autotix/conf
  readOnly: true
{{- end }}
