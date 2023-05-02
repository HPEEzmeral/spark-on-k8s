{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "spark-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark-operator.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

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
Common labels
*/}}
{{- define "spark-operator.labels" -}}
helm.sh/chart: {{ include "spark-operator.chart" . }}
{{ include "spark-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spark-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels for autoticket generator
*/}}
{{- define "autoticket-generator.selectorLabels" -}}
app: autoticket-generator-app
{{- end }}

{{/*
Create the name of the service account to be used by the operator
*/}}
{{- define "spark-operator.serviceAccountName" -}}
{{- if .Values.serviceAccounts.sparkoperator.create -}}
{{ default (include "spark-operator.fullname" .) .Values.serviceAccounts.sparkoperator.name }}
{{- else -}}
{{ default "default" .Values.serviceAccounts.sparkoperator.name }}
{{- end -}}
{{- end -}}

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

{{/*
Create the name of the service account to be used by autoticket generator
*/}}
{{- define "autotix.serviceAccountName" -}}
{{- if .Values.serviceAccounts.autotix.create -}}
{{- printf "%s-%s" "hpe" "autoticket-generator" | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{ default "default" .Values.serviceAccounts.autotix.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the webhook Init pod
*/}}
{{- define "spark-operator.webhookInitName" -}}
    {{- printf "%s-webhook-init" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the autotix Init pod
*/}}
{{- define "spark-operator.autotixInitName" -}}
    {{- printf "%s-autotix-init" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the webhook
*/}}
{{- define "spark-operator.webhookName" -}}
    {{- printf "%s-webhook" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the webhook config
*/}}
{{- define "spark-operator.webhookConfigName" -}}
    {{- printf "%s-webhook-config" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the webhook cleanup pod
*/}}
{{- define "spark-operator.webhookCleanUpName" -}}
    {{- printf "%s-webhook-cleanup" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the autoticket generator cleanup pod
*/}}
{{- define "spark-operator.autotixCleanUpName" -}}
    {{- printf "%s-autotix-cleanup" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*Create a autoticket generator configmap name
*/}}
{{- define "autoticket-generator.configMapName" -}}
{{- printf "%s-%s" .Values.autotix.autotixName "cm"  | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a autoticket generator service name
*/}}
{{- define "autoticket-generator.svcName" -}}
{{- printf "%s-%s" .Values.autotix.autotixName "svc" | trunc 63 | trimSuffix "-" }}
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
- name : spark-app-configure-label
  value: "{{ .Values.autotix.configureLabel }}"
- name: SET_SPARK_USERNAME
  value: "{{ .Values.autotix.autoSetSparkUserNameEnvs }}"
{{- end }}

{{/*
return volume for autoticket-generator container
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
return volumeMounts for autoticket-generator container
*/}}
{{- define "autoticket-generator.volumesMounts" -}}
- name: autoticket-generator-certs
  mountPath:  /opt/validator/certs
  readOnly: true
- name: autoticket-generator-cm
  mountPath:  /opt/autotix/conf
  readOnly: true
{{- end }}
