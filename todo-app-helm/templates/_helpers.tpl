{{- define "todo-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "todo-app.namespace" -}}
{{ .Values.namespace }}
{{- end }}
