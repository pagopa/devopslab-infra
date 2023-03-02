componentType: state.azure.cosmosdb
version: v1
metadata:
- name: url
  value: https://dvopla-d-neu-diego-diego-dapr-cosmos.mongo.cosmos.azure.com:443/
- name: masterkey
  secretRef: cosmoskey
- name: database
  value: mydbdapr
- name: collection
  value: mycollectiondapr
secrets:
- name: cosmoskey
  value: "${COSMOSDB_KEY}"
