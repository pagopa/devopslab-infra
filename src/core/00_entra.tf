#
# Azure AD Access Policy
#
data "azuread_group" "adgroup_admin" {
  display_name = "${local.project}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.project}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.project}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.project}-adgroup-security"
}
