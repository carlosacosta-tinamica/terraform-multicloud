provider "azurerm" {
  features {}
}

# Referencia al grupo de recursos existente
data "azurerm_resource_group" "existing" {
  name = "rg-earis-res-001"
}

# Referencia a la VNet existente
data "azurerm_virtual_network" "existing_vnet" {
  name                = "vnet-tf-demo"       # Cambia si tu VNet real tiene otro nombre
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Nueva subred dentro de la VNet existente
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-tf-demo"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# NIC para Windows
resource "azurerm_network_interface" "nic_windows" {
  name                = "nic-tf-win"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "ipconfig-win"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NIC para Linux
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-tf-linux"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "ipconfig-linux"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM Windows Server
resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                = "vm-tf-win"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "131560carlos*AZURE2024!"
  network_interface_ids = [
    azurerm_network_interface.nic_windows.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-tf-win"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# VM Linux (Ubuntu)
resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                = "vm-tf-linux"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "131560carlos*AZURE2024!"  # O usa SSH para mayor seguridad
  network_interface_ids = [
    azurerm_network_interface.nic_linux.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-tf-linux"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts"
    version   = "latest"
  }
}
