resource "opennebula_template" "confidential_vm_template" {
  name        = "confidential-sgx-template"
  permissions = "660"
  group       = "oneadmin"
  #–– Recursos de cómputo ––
  memory = 1024 # MiB
  cpu    = 1    # fracción de core
  vcpu   = 1    # núcleos virtuales asignados

  #–– Contextualización ––
  context = {
    NETWORK         = "YES"
    USERNAME        = "admin"
    PASSWORD_BASE64 = "YWRtaW4x"
    SSH_PUBLIC_KEY  = "$USER[SSH_PUBLIC_KEY]"
    SET_HOSTNAME    = "$NAME"
    START_SCRIPT    = "echo -e '123456\n123456' | passwd root |sudo apt-get update -y && sudo apt-get install sshpass -y"
  }
  #–– Parámetros de arranque ––
  os {
    arch = "x86_64"
    boot = "disk0"
  }
  #–– Modelo de CPU ––
  cpumodel {
    model = "host-passthrough" # expone las instrucciones SGX del host
  }
  #–– Consola gráfica ––
  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "es"
  }

  disk {
    image_id = opennebula_image.ubuntu_image.id # imagen a utilizar creada an el fichero main.tf
    size     = 10000                            # capacidad del disco virtual en MB
    target   = "vda"
    driver   = "qcow2"
  }
  #–– Interfaz de red ––
  nic {
    model           = "virtio"
    network_id      = opennebula_virtual_network.private_net.id
    security_groups = [opennebula_security_group.basic_sg.id]
  }
  #–– Habilitar SGX en libvirt / KVM ––
  raw {
    type = "kvm"
    data = "<cpu mode='host-passthrough'><feature policy='require' name='sgx'/></cpu>"
  }
  tags = {
    environment     = "uoclab"
    deployment_mode = "terraform"
    image           = "ubuntu 24.04"
    LABELS          = "ubuntu,terraform,cloud-pro"
  }
}

resource "opennebula_template" "confidential_vm_templat_luks" {
  name        = "confidential-sgx-template_luks"
  permissions = "660"
  group       = "oneadmin"
  #–– Recursos de cómputo ––
  memory = 1024 # MiB
  cpu    = 1    # fracción de core
  vcpu   = 1    # núcleos virtuales asignados

  #–– Contextualización ––
  context = {
    NETWORK         = "YES"
    USERNAME        = "admin"
    PASSWORD_BASE64 = "YWRtaW4x"
    SSH_PUBLIC_KEY  = "$USER[SSH_PUBLIC_KEY]"
    SET_HOSTNAME    = "$NAME"
    START_SCRIPT    = "echo -e '123456\n123456' | passwd root |sudo apt-get update -y && sudo apt-get install sshpass -y"
  }
  #–– Parámetros de arranque ––
  os {
    arch = "x86_64"
    boot = "disk0"
  }
  #–– Modelo de CPU ––
  cpumodel {
    model = "host-passthrough" # expone las instrucciones SGX del host
  }
  #–– Consola gráfica ––
  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "es"
  }

  disk {
    image_id = opennebula_image.ubuntu_image.id # imagen a utilizar creada an el fichero main.tf
    size     = 10000                            # capacidad del disco virtual en MB
    target   = "vda"
    driver   = "raw"
  }
  #–– Interfaz de red ––
  nic {
    model           = "virtio"
    network_id      = opennebula_virtual_network.private_net.id
    security_groups = [opennebula_security_group.basic_sg.id]
  }
  #–– Habilitar SGX en libvirt / KVM ––
  raw {
    type = "kvm"
    data = "<cpu mode='host-passthrough'><feature policy='require' name='sgx'/></cpu>"
  }
  tags = {
    environment     = "uoclab"
    deployment_mode = "terraform"
    image           = "ubuntu 24.04"
    LABELS          = "ubuntu,terraform,vm_luks,cloud-pro"
  }
}
