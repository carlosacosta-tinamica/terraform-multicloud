provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "existing" {
  name = "rg-earis-res-001"
}

data "azurerm_virtual_network" "existing_vnet" {
  name                = "vnet-tf-demo"
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet-tf-demo"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

# NIC para Windows
resource "azurerm_network_interface" "nic_windows" {
  name                = "nic-tf-win3" # Nombre único nuevo
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "ipconfig-win"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NIC para Linux
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-tf-linux2" # Nombre único nuevo
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "ipconfig-linux"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM Windows Server (nombre, NIC y disco únicos)
resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                = "vm-tf-win3"  # Nombre único nuevo
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
    name                 = "osdisk-tf-win3"  # Nombre único nuevo
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# VM Linux (nombre, NIC y disco únicos)
resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                = "vm-tf-linux2" # Nombre único nuevo
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "131560carlos*AZURE2024!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_linux.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-tf-linux2"  # Nombre único nuevo
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts"
    version   = "latest"
  }
}
