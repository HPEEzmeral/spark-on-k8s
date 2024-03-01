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
{{- printf "%s-%s" "hpe" (include "autoticket-generator.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels for autoticket generator
*/}}
{{- define "autoticket-generator.selectorLabels" -}}
app: autoticket-generator-app
{{- end }}

{{/*
Create a autoticket generator CertManager Certificate
*/}}
{{- define "autoticket-generator.certManagerCertificate" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "cert" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator CertManager Issuer
*/}}
{{- define "autoticket-generator.certManagerIssuer" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "selfsigned-issuer" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator configmap name
*/}}
{{- define "autoticket-generator.configMapName" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "cm" | trunc 63 | trimSuffix "-" }}
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
Create a autoticket generator service name
*/}}
{{- define "autoticket-generator.svcName" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "svc" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator MutatingWebhook
*/}}
{{- define "autoticket-generator.webhookMutatingName" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "validating" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator MutatingWebhookConfiguration
*/}}
{{- define "autoticket-generator.webhookMutatingConfigurationName" -}}
{{- printf "%s-%s" (include "autoticket-generator.webhookMutatingName" .) "cfg" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator ValidatingWebhook
*/}}
{{- define "autoticket-generator.webhookValidatingName" -}}
{{- printf "%s-%s" (include "autoticket-generator.name" .) "validating" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a autoticket generator ValidatingWebhookConfiguration
*/}}
{{- define "autoticket-generator.webhookValidatingConfigurationName" -}}
{{- printf "%s-%s" (include "autoticket-generator.webhookValidatingName" .) "cfg" | trunc 63 | trimSuffix "-" }}
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
- name: autoticket-generator-cert
  secret:
    secretName: autoticket-generator-cert
- name: autoticket-generator-cm
  configMap:
    name: {{ include "autoticket-generator.configMapName" . }}
{{- end }}

{{/*
Return volumeMounts for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumesMounts" -}}
- name: autoticket-generator-cert
  mountPath: /tmp/k8s-webhook-server/serving-certs
  readOnly: true
- name: autoticket-generator-cm
  mountPath: /opt/autotix/conf
  readOnly: true
{{- end }}
