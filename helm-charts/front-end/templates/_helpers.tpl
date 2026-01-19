{{- define "frontend" -}}
app: frontend
env: {{ .Values.app.env }}
{{- end -}}