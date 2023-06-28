resource "kubernetes_config_map" "changed" {
  metadata {
    name = "mock-my-changed"
  }

  data = {
    api_host             = "msdasdasdst:443"
    db_host              = "dbhodasdas432"
  }
}

# resource "kubernetes_config_map" "deleted" {
#   metadata {
#     name = "mock-my-deleted"
#   }

#   data = {
#     api_host             = "myhost:443"
#     db_host              = "dbhost:5432"
#   }
# }

resource "kubernetes_config_map" "replaced" {
  metadata {
    name = "mock-my-replaced-new"
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
  }
}

resource "kubernetes_config_map" "added" {
  metadata {
    name = "mock-my-added"
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
  }
}
