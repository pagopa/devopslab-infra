apiVersion: v1
kind: Secret
metadata:
  name: sftp-stress-keys
  namespace: ${namespace}
type: Opaque
data:
  matteo: ${matteo_private_key}

