apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: games
  namespace: argocd
  labels:
    argo-project: "argo-${namespace}"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: "${namespace}"

  source:
    repoURL: "${deployment_repo_url}"
    targetRevision: "${target_revision}"
    path: argocd

    helm:
      valueFiles:
        - values.yaml
      parameters:
        ### SERVICE
        - name: foo
          value: "bar"
          forceString: true


  # Destination cluster and namespace to deploy the application
  destination:
    server: https://kubernetes.default.svc
    namespace: "${namespace}"

  # Sync policy
  syncPolicy:
    automated: # automated sync by default retries failed attempts 5 times with following delays between attempts ( 5s, 10s, 20s, 40s, 80s ); retry controlled using `retry` field.
      prune: true # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true # Specifies if partial app sync should be executed when resources are changed only in target Kubernetes cluster and no git change detected ( false by default ).
      allowEmpty: false # Allows deleting all application resources during automatic syncing ( false by default ).
    syncOptions:     # Sync options which modifies sync behavior
    - Validate=false # disables resource validation (equivalent to 'kubectl apply --validate=false') ( true by default ).
    - CreateNamespace=true # Namespace Auto-Creation ensures that namespace specified as the application destination exists in the destination cluster.
    - PrunePropagationPolicy=foreground # Supported policies are background, foreground and orphan.
    - PruneLast=true # Allow the ability for resource pruning to happen as a final, implicit wave of a sync operation
    # The retry feature is available since v1.7
    retry:
      limit: 5 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 5s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
        factor: 2 # a factor to multiply the base duration after each failed retry
        maxDuration: 3m # the maximum amount of time allowed for the backoff strategy

  # Will ignore differences between live and desired states during the diff. Note that these configurations are not
  # used during the sync process.
  ignoreDifferences:
  # for the specified json pointers
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas
  # for the specified managedFields managers
  - group: "*"
    kind: "*"
    managedFieldsManagers:
    - kube-controller-manager
