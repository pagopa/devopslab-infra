resource "azurerm_resource_group" "redis" {
  name     = "${local.project}-redis-rg"
  location = var.location
  tags     = var.tags
}

## redisbase subnet
module "redis_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.23.0"
  name                 = "${local.project}-redis-snet"
  address_prefixes     = var.cidr_subnet_redis
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
}

module "redis" {
  count                 = var.redis_enabled ? 1 : 0
  source                = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v7.23.0"
  name                  = "${local.project}-redis"
  resource_group_name   = azurerm_resource_group.redis.name
  location              = azurerm_resource_group.redis.location
  capacity              = 1
  enable_non_ssl_port   = false
  family                = "C"
  sku_name              = "Basic"
  enable_authentication = true
  redis_version = 6
  zones = null

  private_endpoint = {
    enabled              = true
    virtual_network_id   = module.vnet.id
    subnet_id            = module.redis_snet.id
    private_dns_zone_ids = [azurerm_private_dns_zone.internal_devopslab[0].id]
  }

  tags = var.tags
}
