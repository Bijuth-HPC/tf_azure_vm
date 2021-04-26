resource "azurerm_resource_group" "tf_vm_rg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "tf_vm_vnet" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.tf_vm_rg.location
  resource_group_name = azurerm_resource_group.tf_vm_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "tf_vm_subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.tf_vm_vnet.name
  resource_group_name  = azurerm_resource_group.tf_vm_rg.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_public_ip" "tf_vm_public_ip" {
  name                         = "${var.prefix}-public_ip"
  location                     = azurerm_resource_group.tf_vm_rg.location
  resource_group_name          = azurerm_resource_group.tf_vm_rg.name
  domain_name_label            = var.tf_vm_dns_label
  allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "tf_vm_nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.tf_vm_rg.location
  resource_group_name = azurerm_resource_group.tf_vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf_vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_vm_public_ip.id
  }
}
 
resource "azurerm_network_security_group" "tf_vm_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.tf_vm_rg.location
  resource_group_name = azurerm_resource_group.tf_vm_rg.name
 
}
 
resource "azurerm_network_security_rule" "tf_vm_nsg_rules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.tf_vm_rg.name
  network_security_group_name = azurerm_network_security_group.tf_vm_nsg.name
}

resource "azurerm_network_interface_security_group_association" "tf_vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.tf_vm_nic.id
  network_security_group_id = azurerm_network_security_group.tf_vm_nsg.id
}

