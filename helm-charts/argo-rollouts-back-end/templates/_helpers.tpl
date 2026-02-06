{{- define "app-label" -}}
app: app-label
env: {{ .Values.rollout.app.env }}
{{- end -}}

{{- define "rollout.analysis.errorRate" -}}
templates:
  - templateName: error-rate
{{- end }}