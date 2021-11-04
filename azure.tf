locals {
  user_data = <<EOF
#!/bin/bash
sudo hostnamectl set-hostname "BU2-App"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo 'ubuntu:${var.host_password}' | /usr/sbin/chpasswd
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install traceroute unzip build-essential git gcc hping3 apache2 net-tools
sudo apt autoremove
sudo /etc/init.d/ssh restart
EOF
}

resource "azurerm_network_interface" "main" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        name                = "${each.key}-nic1"
        resource_group_name = module.azure_spoke["${each.key}"].vnet.resource_group
        location            = each.value.region
        ip_configuration {
            name                          = module.azure_spoke["${each.key}"].vnet.private_subnets[0].name
            subnet_id                     = module.azure_spoke["${each.key}"].vnet.private_subnets[0].subnet_id
            private_ip_address_allocation = "Dynamic"
        }
}

resource "azurerm_network_security_group" "spoke-host" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        name                = "${each.key}-host"
        resource_group_name = module.azure_spoke["${each.key}"].vnet.resource_group
        location            = each.value.region
}

resource "azurerm_network_security_rule" "http" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        access                      = "Allow"
        direction                   = "Inbound"
        name                        = "http"
        priority                    = 100
        protocol                    = "Tcp"
        source_port_range           = "*"
        source_address_prefix       = "*"
        destination_port_range      = "80"
        destination_address_prefix  = "*"
        resource_group_name         = module.azure_spoke["${each.key}"].vnet.resource_group
        network_security_group_name = azurerm_network_security_group.spoke-host["${each.key}"].name
}

resource "azurerm_network_security_rule" "ssh" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        access                      = "Allow"
        direction                   = "Inbound"
        name                        = "ssh"
        priority                    = 110
        protocol                    = "Tcp"
        source_port_range           = "*"
        source_address_prefix       = "*"
        destination_port_range      = "22"
        destination_address_prefix  = "*"
        resource_group_name         = module.azure_spoke["${each.key}"].vnet.resource_group
        network_security_group_name = azurerm_network_security_group.spoke-host["${each.key}"].name
}

resource "azurerm_network_security_rule" "icmp" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        access                      = "Allow"
        direction                   = "Inbound"
        name                        = "icmp"
        priority                    = 120
        protocol                    = "Icmp"
        source_port_range           = "*"
        source_address_prefix       = "*"
        destination_port_range      = "*"
        destination_address_prefix  = "*"
        resource_group_name         = module.azure_spoke["${each.key}"].vnet.resource_group
        network_security_group_name = azurerm_network_security_group.spoke-host["${each.key}"].name
}

resource "azurerm_network_interface_security_group_association" "main" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        network_interface_id      = azurerm_network_interface.main["${each.key}"].id
        network_security_group_id = azurerm_network_security_group.spoke-host["${each.key}"]-host.id
}

resource "azurerm_linux_virtual_machine" "azure_spoke_vm" {
    for_each =  {for key, value in var.gateways.spoke: key => value if coalesce(value.attach_host,false) && value.account == var.accounts.azure && value.region == "US Central"}
        name                            = "${each.key}-host"
        resource_group_name             = module.azure_spoke["${each.key}"].vnet.resource_group
        location                        = each.value.region
        size                            = var.azure_test_instance_size
        admin_username                  = "ubuntu"
        admin_password                  = var.host_password
        disable_password_authentication = false
        network_interface_ids = [
            azurerm_network_interface.main["${each.key}"].id,
        ]
        source_image_reference {
            publisher = "Canonical"
            offer     = "UbuntuServer"
            sku       = "18.04-LTS"
            version   = "latest"
        }
        # source_image_reference {
        #   publisher = "canonical"
        #   offer     = "0001-com-ubuntu-server-focal"
        #   version   = "latest"
        # }
        os_disk {
            storage_account_type = "Standard_LRS"
            caching              = "ReadWrite"
        }
        custom_data = base64encode(local.user_data)
}