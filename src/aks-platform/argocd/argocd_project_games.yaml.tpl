apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: "${project_name}"
  namespace: argocd
    # Finalizer that ensures that project is not deleted until it is not referenced by any application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  #
  description: This project hosts ${project_name} related deployments.

  sourceRepos:
    - '${deployment_repo_url}'

  # Only permit applications to deploy to namespaces in the same cluster
  destinations:
    - server: "https://kubernetes.default.svc"
      namespace: "${namespace}"
    #needed to install applications
    - server: "https://kubernetes.default.svc"
      namespace: "argocd"

  clusterResourceWhitelist:
    - group: '*'
      kind: Namespace
    - group: '*'
      kind: CustomResourceDefinition
    - group: '*'
      kind: ClusterRole
    - group: '*'
      kind: ClusterRoleBinding
    - group: '*'
      kind: ClusterIssuer
    - group: '*'
      kind: PersistentVolume
    - group: admissionregistration.k8s.io
      kind: ValidatingWebhookConfiguration

  # Allow all namespaced-scoped resources to be created, except for ResourceQuota, LimitRange, NetworkPolicy
  namespaceResourceBlacklist:
    - group: ''
      kind: ResourceQuota
    - group: ''
      kind: LimitRange
    - group: ''
      kind: NetworkPolicy

  # # Deny all namespaced-scoped resources from being created, except for Deployment and StatefulSet
  # namespaceResourceWhitelist:
  #   - group: 'apps'
  #     kind: Deployment
  #   - group: 'apps'
  #     kind: StatefulSet

  # Enables namespace orphaned resource monitoring.
  orphanedResources:
    warn: false

  roles:
    # A role which provides read-only access to all applications in the project
    - name: read-only
      description: Read-only privileges to infrastructure
      policies:
        - p, proj:${project_name}:read-only, applications, get, ${project_name}/*, allow
      groups:
        - my-oidc-group

    # A role which provides sync privileges to all applications, e.g. to provide sync privileges to a CI system
    - name: ci-role
      description: Sync privileges for infrastructure
      policies:
        - p, proj:${project_name}:cd-role, applications, sync, ${project_name}/*, allow
