{{/*
Returns standard volume mounts
*/}}
{{- define "common.volumeMounts" -}}
- mountPath: "/opt/mapr/logs"
  name: logs
- mountPath: "/opt/mapr/mapr-cli-audit-log"
  name: logs
- mountPath: "/opt/cores"
  name: cores
- mountPath: "/opt/mapr/kubernetes/cluster-cm"
  name: cluster-cm
- mountPath: "/opt/mapr/kubernetes/replace-cm"
  name: replace-cm
- mountPath: "/opt/mapr/kubernetes/status-cm"
  name: status-cm
{{- end }}

{{- define "sssd.volumeMounts" -}}
- mountPath: "/opt/mapr/kubernetes/sssd-secrets"
  name: sssd-secrets
- mountPath: "/opt/mapr/kubernetes/ldap-cm"
  name: ldap-cm
{{- end }}

{{- define "ssh.volumeMounts" -}}
- mountPath: "/opt/mapr/kubernetes/ssh-secrets"
  name: ssh-secrets
{{- end }}

{{- define "common.security.volumeMounts" -}}
- mountPath: "/opt/mapr/kubernetes/client-secrets"
  name: client-secrets
- mountPath: "/opt/mapr/kubernetes/server-secrets"
  name: server-secrets
{{- end }}

{{- define "sssd.security.volumeMounts" -}}
- mountPath: /opt/mapr/kubernetes/ldapcert-secrets
  name: ldapcert-secret
{{- end }}
