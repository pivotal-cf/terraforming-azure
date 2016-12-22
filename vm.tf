resource "azurerm_public_ip" "ops_manager_public_ip" {
  name                         = "${var.env_name}-ops-manager-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "optional_ops_manager_public_ip" {
  name                         = "${var.env_name}-optional-ops-manager-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
  count                        = "${min(length(split("", var.optional_ops_manager_image_uri)),1)}"
}

resource "azurerm_network_interface" "ops_manager_nic" {
  name                = "${var.env_name}-ops-manager-nic"
  depends_on          = ["azurerm_public_ip.ops_manager_public_ip"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  ip_configuration {
    name                          = "${var.env_name}-ops-manager-ip-config"
    subnet_id                     = "${azurerm_subnet.opsman_and_director_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.8.4"
    public_ip_address_id          = "${azurerm_public_ip.ops_manager_public_ip.id}"
  }
}

resource "azurerm_network_interface" "optional_ops_manager_nic" {
  name                = "${var.env_name}-optional-ops-manager-nic"
  depends_on          = ["azurerm_public_ip.optional_ops_manager_public_ip"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  count               = "${min(length(split("", var.optional_ops_manager_image_uri)),1)}"

  ip_configuration {
    name                          = "${var.env_name}-optional-ops-manager-ip-config"
    subnet_id                     = "${azurerm_subnet.opsman_and_director_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.8.5"
    public_ip_address_id          = "${azurerm_public_ip.optional_ops_manager_public_ip.id}"
  }
}

resource "azurerm_virtual_machine" "ops_manager_vm" {
  name                          = "${var.env_name}-ops-manager-vm"
  depends_on                    = ["azurerm_network_interface.ops_manager_nic", "azurerm_storage_blob.ops_manager_image"]
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.pcf_resource_group.name}"
  network_interface_ids         = ["${azurerm_network_interface.ops_manager_nic.id}"]
  vm_size                       = "Standard_DS2_v2"
  delete_os_disk_on_termination = "true"

  storage_os_disk {
    name          = "opsman-disk.vhd"
    vhd_uri       = "${azurerm_storage_account.ops_manager_storage_account.primary_blob_endpoint}${azurerm_storage_container.ops_manager_storage_container.name}/opsman-disk.vhd"
    image_uri     = "${azurerm_storage_blob.ops_manager_image.url}"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
    disk_size_gb  = "100"
  }

  os_profile {
    computer_name  = "${var.env_name}-ops-manager"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }
}

resource "azurerm_virtual_machine" "optional_ops_manager_vm" {
  name                  = "${var.env_name}-optional-ops-manager-vm"
  depends_on            = ["azurerm_network_interface.optional_ops_manager_nic", "azurerm_storage_blob.optional_ops_manager_image"]
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.optional_ops_manager_nic.id}"]
  vm_size               = "Standard_DS2_v2"
  count                 = "${min(length(split("", var.optional_ops_manager_image_uri)),1)}"

  storage_os_disk {
    name          = "optional-opsman-disk.vhd"
    vhd_uri       = "${azurerm_storage_account.ops_manager_storage_account.primary_blob_endpoint}${azurerm_storage_container.ops_manager_storage_container.name}/optional-opsman-disk.vhd"
    image_uri     = "${azurerm_storage_blob.optional_ops_manager_image.url}"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
    disk_size_gb  = "100"
  }

  os_profile {
    computer_name  = "${var.env_name}-optional-ops-manager"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }
}
