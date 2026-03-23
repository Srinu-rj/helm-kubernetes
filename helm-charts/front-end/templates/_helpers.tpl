{{- define "frontend" -}}
app: frontend
env: {{ .Values.app.env }}
{{- end -}}

{{- define "backend.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "frontend.testLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
helm.sh/test: "true"
{{- end }}

{{- define "backend.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "frontend.namespace" -}}
{{- .Values.namespace.defaultNamespace | default .Values.namespace.name | default "default" }}
{{- end }}