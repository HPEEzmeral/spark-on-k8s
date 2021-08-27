{{/*
Return a liveness probe
*/}}
{{- define "common.probe.liveness" -}}
exec:
    command:
        - "/opt/mapr/kubernetes/isOk.sh"
initialDelaySeconds: 600
failureThreshold: 3
periodSeconds: 10
successThreshold: 1
timeoutSeconds: 1
{{- end }}

{{/*
Return a readiness probe
*/}}
{{- define "common.probe.readiness" -}}
exec:
    command:
        - "/opt/mapr/kubernetes/isReady.sh"
failureThreshold: 3
periodSeconds: 10
successThreshold: 1
timeoutSeconds: 1
{{- end }}

{{/*
Return a lifecycle
*/}}
{{- define "common.probe.lifecycle" -}}
preStop:
    exec:
        command:
            - "sh"
            - "/opt/mapr/kubernetes/pre-stop.sh"
{{- end }}