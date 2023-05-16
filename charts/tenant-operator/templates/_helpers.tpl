{{/*
return name for operator
*/}}.
{{- define "tenant-operator.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
return name for validator
*/}}
{{- define "tenant-validator.name" -}}
{{- printf "%s" "tenant-validator" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant operator name with prefix hpe
*/}}
{{- define "tenant-operator.hpePrefix" -}}
{{- printf "%s-%s" "hpe" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant validator service name
*/}}
{{- define "tenant-validator.svcName" -}}
{{- printf "%s-%s" .Values.tenantValidatorName "svc" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant validator post install hook name
*/}}
{{- define "tenant-validator.postInstallHookName" -}}
{{- printf "%s-%s" .Values.tenantValidatorName "init" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant validator pre delete hook name
*/}}
{{- define "tenant-validator.preDeleteHookName" -}}
{{- printf "%s-%s" .Values.tenantValidatorName "cleanup" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*Create a tenant validator name with prefix hpe service account
*/}}
{{- define "tenant-validator.hpePrefix" -}}
{{- printf "%s-%s" "hpe" .Values.tenantValidatorName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
return namespace where the tenant operator and validator must be deployed
*/}}
{{- define "tenant-operator.namespace" -}}
{{- printf "%s" .Release.Namespace | trunc 63 | trimSuffix "-" }}
{{- end}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tenant-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
return selector labels for operator
*/}}
{{- define "tenant-operator.selectorLabels" -}}
app: {{ .Chart.Name }}
{{- end }}

{{/*
return selector labels for validator
*/}}
{{- define "tenant-validator.selectorLabels" -}}
app: tenant-validator-app
{{- end }}

{{/*
return tolerations for tenant components
*/}}
{{- define "tenant-operator.tolerations" -}}
- key: node-role.kubernetes.io/master
  operator: Exists
{{- end }}

{{/*
return podAntiAffinity for tenant components
*/}}
{{- define "tenant-operator.podAntiAffinity.preferred" -}}
- podAffinityTerm:
    labelSelector:
        matchExpressions:
            - key: "app"
              operator: "In"
              values:
                - {{ .Chart.Name }}
    topologyKey: "kubernetes.io/hostname"
  weight: 1
{{- end }}

{{/*
return env for operator container
*/}}
{{- define "tenant-operator.env" -}}
- name : WATCH_NAMESPACE
  value: ""
- name: POD_NAME
  valueFrom:
      fieldRef:
        fieldPath: metadata.name
- name : OPERATOR_NAME
  value: "tenant-operator"
- name : K8S_TYPE
  value: "vanilla"
- name : LOG_LEVEL
  value: "info"
{{- end }}

{{/*
return env for validator container
*/}}
{{- define "tenant-validator.env" -}}
- name : LOG_LEVEL
  value: "info"
{{- end }}

{{/*
return args for operator container
*/}}
{{- define "tenant-operator.args" -}}
- --zap-devel
{{- end }}

{{/*
return commands for operator container
*/}}
{{- define "tenant-operator.commands" -}}
- /usr/local/bin/tenant-operator
{{- end }}

{{/*
return volume for validator container
*/}}
{{- define "tenant-validator.volumes" -}}
- name: tenant-validator-certs
  secret:
    secretName: tenant-validator-certs
{{- end }}

{{/*
return volumeMounts for validator container
*/}}
{{- define "tenant-validator.volumesMounts" -}}
- name: tenant-validator-certs
  mountPath:  /opt/validator/certs
  readOnly: true
{{- end }}

