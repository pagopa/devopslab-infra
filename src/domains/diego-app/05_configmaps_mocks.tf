resource "kubernetes_config_map" "changed" {
  metadata {
    name = "mock-my-changed"
    namespace = var.domain
  }

  data = {
    api_host             = "msasdasdst:443"
    db_host              = "dbhasdasdasdassdas432"
  }
}

# resource "kubernetes_config_map" "deleted" {
#   metadata {
#     name = "mock-my-deleted"
#     namespace = var.domain
#   }

#   data = {
#     api_host             = "myhost:443"
#     db_host              = "dbhost:5432"
#   }
# }

resource "kubernetes_config_map" "replaced" {
  metadata {
    name = "mock-my-replaced"
    namespace = var.domain
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
  }
}

resource "kubernetes_config_map" "added" {
  metadata {
    name = "mock-my-added"
      namespace = var.domain
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
  }
}
