controller:
  keda:
    enabled: true
    minReplicas: ${min_replicas}
    maxReplicas: ${max_replicas}
    triggers:
      ${indent(6, yamlencode(triggers))}
