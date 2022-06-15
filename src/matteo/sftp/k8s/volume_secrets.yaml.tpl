apiVersion: v1
kind: Secret
metadata:
  name: sftp-stress-volume
  namespace: ${namespace}
type: Opaque
data:
  azurestorageaccountname: ${account_name}
  azurestorageaccountkey: ${account_key}

