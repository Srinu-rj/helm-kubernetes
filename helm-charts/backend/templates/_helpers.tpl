{{- define "app.label" -}}
app: backend_api
env: {{ .Values.app.env }}
{{- end -}}