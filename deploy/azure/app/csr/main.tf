module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  namespace  = "${var.name_company}-${var.name_project}"
  stage      = var.stage
  name       = "${lookup(var.location_name_map, var.resource_group_location, "northeurope")}-${var.name_component}"
  attributes = var.attributes
  delimiter  = "-"
  tags       = var.tags
}

data "azurerm_client_config" "current" {}

module "static_website" {
  source                   = "git::https://github.com/amido/stacks-terraform//azurerm/modules/azurerm-client-side-ui?ref=v1.4.2"
  resource_namer           = module.default_label.id
  subscription_id          = data.azurerm_client_config.current.subscription_id
  resource_group_location  = var.resource_group_location
  name_company             = var.name_company
  name_project             = var.name_project
  name_component           = var.name_component
  name_environment         = var.name_environment
  resource_tags            = module.default_label.tags
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  dns_zone                 = var.dns_zone
  dns_record               = var.dns_record
  dns_resource_group       = var.dns_resource_group
  create_dns_zone          = var.create_dns_zone
  response_header_cdn      = var.response_header_cdn
}
