---
kind: containerapp
location: northeurope
name: ${CONTAINER_APP_NAME}
resourceGroup: ${CONTAINER_APP_RESOURCE_GROUP}
type: Microsoft.App/containerApps
tags:
  tagname: value
properties:
  managedEnvironmentId: /subscriptions/ac17914c-79bf-48fa-831e-1359ef74c1d5/resourceGroups/${CONTAINER_APP_RESOURCE_GROUP}/providers/Microsoft.App/managedEnvironments/${CONTAINER_APP_ENVIRONMENT_NAME}
  configuration:
    activeRevisionsMode: Single #Setting to single automatically deactivates old revisions, and only keeps the latest revision active. Setting to multiple allows you to maintain multiple revisions.
    secrets:
      - name: dvopla-d-appinsights-connection-string
        value: ${DVOPLA-D-APPINSIGHTS-CONNECTION-STRING}
    ingress:
      external: true
      allowInsecure: false
      targetPort: 8080
      traffic:
        - latestRevision: true
          weight: 100
      transport: Auto
    # registries:
    #   - passwordSecretRef: myregistrypassword
    #     server: myregistry.azurecr.io
    #     username: myregistrye
    # dapr:
    #   appId: mycontainerapp
    #   appPort: 80
    #   appProtocol: http
    #   enabled: true
  template:
    revisionSuffix: rev-${REVISION_ID}
    containers:
      - image: ghcr.io/pagopa/devops-java-springboot-color:0.8.1
        name: devops-java-springboot-color
        env:
          - name: APPLICATIONINSIGHTS_CONNECTION_STRING
            secretRef: dvopla-d-appinsights-connection-string
        resources:
          cpu: 0.5
          memory: 1Gi
        probes:
          - type: liveness
            httpGet:
              path: "/status"
              port: 8080
              # httpHeaders:
              #   - name: "Custom-Header"
              #     value: "liveness probe"
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 6
            timeoutSeconds: 10
          - type: readiness
            httpGet:
              path: "/status"
              port: 8080
            # tcpSocket:
            #   port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 6
            timeoutSeconds: 10
          - type: startup
            httpGet:
              path: "/status"
              port: 8080
              # httpHeaders:
              #   - name: "Custom-Header"
              #     value: "startup probe"
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 6
            timeoutSeconds: 10
    scale:
      minReplicas: 0
      maxReplicas: 3
