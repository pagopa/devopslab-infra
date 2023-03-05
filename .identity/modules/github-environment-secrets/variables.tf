variable "github_repository" {
  type        = string
  description = "Github repository name"
}

variable "github_repository_environment_name" {
  type        = string
  description = "Github repository environemt name"
}

variable "secrets" {
  type        = map(any)
  description = "secrets to create"
}
