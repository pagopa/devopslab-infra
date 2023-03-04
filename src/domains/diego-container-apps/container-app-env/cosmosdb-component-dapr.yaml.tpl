componentType: state.azure.cosmosdb
version: v1
metadata:
- name: url
  value: ${COSMOSDB_ENDPOINT}
- name: masterkey
  secretRef: cosmoskey
- name: database
  value: ${COSMOSDB_DATABASE}
- name: collection
  value: ${COSMOSDB_COLLECTION}
secrets:
- name: cosmoskey
  value: "${COSMOSDB_KEY}"
