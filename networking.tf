provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.resource_group_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  depends_on          = [azurerm_resource_group.example]
}

resource "azurerm_subnet" "example" {
  name                 = "${var.resource_group_name}-internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  count               = var.count_servers
  name                = "${var.resource_group_name}-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
    primary                       = true
  }
}

resource "azurerm_public_ip" "example" {
  count               = var.count_servers
  name                = "${var.resource_group_name}-publicIp-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.dns_prefix}-${count.index}"

  tags = {
    environment = "Development"
  }
}