{{/*
returns default env for containers

Usage:
{{ include "common.defaultEnv" (dict "containerName" "example-name") }}

Params:
  - containerName - String - Required. Used to add container name to env
*/}}
{{- define "common.defaultEnv" -}}
- name: KUBERNETES_CONTAINER
  value: 'true'
- name: LOG_LEVEL
  value: ERROR
- name: SECURE_CLUSTER
  valueFrom:
    configMapKeyRef:
      key: SECURE_CLUSTER
      name: cluster-cm
- name: USE_SSSD
  valueFrom:
    configMapKeyRef:
      key: USE_SSSD
      name: cluster-cm
- name: USE_SSH
  valueFrom:
    configMapKeyRef:
      key: USE_SSH
      name: cluster-cm
- name: MAPR_CLUSTER
  valueFrom:
    configMapKeyRef:
      key: MAPR_CLUSTER
      name: cluster-cm
- name: CLUSTER_NAMESPACE
  valueFrom:
    configMapKeyRef:
      key: CLUSTER_NAMESPACE
      name: cluster-cm
- name: MAPR_VERSION
  valueFrom:
    configMapKeyRef:
      key: MAPR_VERSION
      name: cluster-cm
- name: DNS_DOMAIN
  valueFrom:
    configMapKeyRef:
      key: DNS_DOMAIN
      name: cluster-cm
- name: LOG_HOSTPATH
  valueFrom:
    configMapKeyRef:
      key: LOG_HOSTPATH
      name: cluster-cm
- name: LOG_MOUNTPATH
  valueFrom:
    configMapKeyRef:
      key: LOG_MOUNTPATH
      name: cluster-cm
- name: LOG_SYMLINK
  valueFrom:
    configMapKeyRef:
      key: LOG_SYMLINK
      name: cluster-cm
- name: CORES_HOSTPATH
  valueFrom:
    configMapKeyRef:
      key: CORES_HOSTPATH
      name: cluster-cm
- name: CORES_MOUNTPATH
  valueFrom:
    configMapKeyRef:
      key: CORES_MOUNTPATH
      name: cluster-cm
- name: CORES_SYMLINK
  valueFrom:
    configMapKeyRef:
      key: CORES_SYMLINK
      name: cluster-cm
- name: PODINFO_HOSTPATH
  valueFrom:
    configMapKeyRef:
      key: PODINFO_HOSTPATH
      name: cluster-cm
- name: PODINFO_MOUNTPATH
  valueFrom:
    configMapKeyRef:
      key: PODINFO_MOUNTPATH
      name: cluster-cm
- name: PODINFO_SYMLINK
  valueFrom:
    configMapKeyRef:
      key: PODINFO_SYMLINK
      name: cluster-cm
- name: MAPR_ZK_HOSTS
  valueFrom:
    configMapKeyRef:
      key: MAPR_ZK_HOSTS
      name: cluster-cm
- name: MAPR_CLDB_HOSTS
  valueFrom:
    configMapKeyRef:
      key: MAPR_CLDB_HOSTS
      name: cluster-cm
- name: MAPR_TSDB_HOSTS
  valueFrom:
    configMapKeyRef:
      key: MAPR_TSDB_HOSTS
      name: cluster-cm
- name: MAPR_ES_HOSTS
  valueFrom:
    configMapKeyRef:
      key: MAPR_ES_HOSTS
      name: cluster-cm
- name: MAPR_HIVEM_HOSTS
  valueFrom:
    configMapKeyRef:
      key: MAPR_HIVEM_HOSTS
      name: cluster-cm
- name: MAPR_TZ
  valueFrom:
    configMapKeyRef:
      key: MAPR_TZ
      name: cluster-cm
- name: MAPR_HOME
  valueFrom:
    configMapKeyRef:
      key: MAPR_HOME
      name: cluster-cm
- name: POD_NAME
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.name
- name: POD_NAMESPACE
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.namespace
- name: NODE_NAME
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: spec.nodeName
- name: HOST_IP
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: status.hostIP
- name: POD_IP
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: status.podIP
- name: POD_SERVICE_ACCOUNT
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: spec.serviceAccountName
- name: K8S_UID
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.uid
- name: MAPR_CPU
  valueFrom:
    resourceFieldRef:
      containerName: {{ .containerName }}
      divisor: '0'
      resource: requests.cpu
- name: MAPR_MEMORY
  valueFrom:
    resourceFieldRef:
      containerName: {{ .containerName }}
      divisor: 1Mi
      resource: requests.memory
- name: MAPR_CPU_LIMIT
  valueFrom:
    resourceFieldRef:
      containerName: {{ .containerName }}
      divisor: '0'
      resource: limits.cpu
- name: MAPR_MEMORY_LIMIT
  valueFrom:
    resourceFieldRef:
      containerName: {{ .containerName }}
      divisor: '0'
      resource: limits.memory
- name: CLUSTER_CREATE_TIME
  value: {{ now | date "20060102150405" | quote }}
{{- end }}
