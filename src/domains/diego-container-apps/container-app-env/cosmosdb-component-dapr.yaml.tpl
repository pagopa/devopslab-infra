componentType: state.azure.cosmosdb
version: v1
metadata:
- name: url
  value: ${COSMOSDB_ENDPOINT}
- name: masterkey
  secretRef: cosmoskey
- name: database
  value: mydbdapr
- name: collection
  value: mycollectiondapr
secrets:
- name: cosmoskey
  value: "${COSMOSDB_KEY}"
