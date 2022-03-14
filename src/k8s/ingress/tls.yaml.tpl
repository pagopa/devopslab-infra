apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: ${secret_name}
  namespace: ${namespace}
spec:
  provider: azure
  secretObjects:
    - secretName: ${secret_name}
      type: kubernetes.io/tls
      data:
      - key: tls.key
        objectName: ${certificate_name}
      - key: tls.crt
        objectName: ${certificate_name}
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: ${identity_id}
    keyvaultName: ${keyvault_name}
    tenantId: ${tenant_id}
    cloudName: ""
    objects: |
      array:
        - |
          objectName: ${certificate_name}
          objectType: secret
          objectVersion: ""
