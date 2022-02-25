resource "azurerm_linux_virtual_machine" "server" {
  count               = var.count_servers
  name                = "server-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.disk_size
  admin_username      = var.user_name
  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
  ]

  admin_ssh_key {
    username   = var.user_name
    public_key = file("${var.pub_key}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "echo Done!"] //, "sudo apt install python3 -y"
  }

  connection {
    type        = "ssh"
    user        = var.user_name
    private_key = file(var.pvt_key)
    host        = self.public_ip_address
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.user_name} -i '${self.public_ip_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.ansible_key} user_name=${var.user_name}' copy-ansible-key.yml"
  }
}

output public_ips {
  value       = azurerm_linux_virtual_machine.server[*].public_ip_address
  description = "The public IP addresses of the created servers."
  depends_on  = [azurerm_linux_virtual_machine.server]
}

