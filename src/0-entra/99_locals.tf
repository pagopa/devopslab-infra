locals {
  product     = "${var.prefix}-${var.env_short}"
  product_ita = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

}
