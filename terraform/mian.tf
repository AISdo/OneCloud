###############################################################################
# 1. IMAGEN
###############################################################################

resource "opennebula_image" "ubuntu_image" {
  name         = "Ubuntu 24.04"
  description  = "Terraform image"
  datastore_id = 1
  persistent   = false
  lock         = "UNLOCK"
  path         = "https://marketplace.opennebula.io//appliance/f4cc1890-f430-013c-b669-7875a4a4f528/download/0"
  dev_prefix   = "vd"
  driver       = "qcow2" # Ajusta si usas otro formato (raw, vmdk...)
  type         = "OS"    # OS, CDROM, DATABLOCK
  permissions  = "660"
  group        = "oneadmin"


  tags = {
    environment = "prod"
  }

  template_section {
    name = "Ubuntu_Dis"
    elements = {
      OS  = "Linux",
      VER = "24.04"
    }
  }
}


resource "opennebula_image" "ubuntu_image_luks" {
  name         = "Ubuntu 24.04 (LUKS)"
  description  = "Terraform image (LUKS-encrypted)"
  datastore_id = 1
  persistent   = false
  lock         = "UNLOCK"
  path         = "/var/tmp/ubuntu24.luks" # ruta del fichero cifrado
  dev_prefix   = "vd"
  driver       = "raw" # LUKS se expone 'raw'
  type         = "OS"  # OS, CDROM, DATABLOCK
  permissions  = "660"
  group        = "oneadmin"


  tags = {
    environment = "prod"
  }

  template_section {
    name = "Ubuntu_Dis"
    elements = {
      OS          = "Linux",
      VER         = "24.04"
      LUKS_SECRET = "e1f493ef-2d1c-43b0-954e-de1fa08f7d7f" # o pon aquí directamente ${UUID}
    }
  }
}


# ###############################################################################
# # 2. SECURITY GROUP BÁSICO
# ###############################################################################

resource "opennebula_security_group" "basic_sg" {
  name        = "security-group"
  permissions = "764"
  description = "Terraform security group"
  group       = "oneadmin"

  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
  }
  # Regla que habilita tráfico TCP entrante en el puerto 22
  rule {
    protocol  = "TCP"
    rule_type = "INBOUND"
    range     = "22"
  }

  rule {
    protocol  = "ICMP"
    rule_type = "INBOUND"
  }
  # Agrega más reglas aquí si lo necesitas (ICMP, otros puertos, etc.)

  tags = {
    environment = "prod"
  }
}



# ###############################################################################
# # 3. RED VIRTUAL PRIVADA
# ###############################################################################
resource "opennebula_virtual_network" "private_net" {
  name        = "terraform-Vnet-FW"
  description = "VMs bridged to 192.168.1.0/24"
  permissions = "660"

  # –– Físico ––
  bridge          = "br0" # bridge configurado previamente
  type            = "fw"  # con security groups
  security_groups = [opennebula_security_group.basic_sg.id]
  # physical_device opcional; OpenNebula lo deduce del bridge

  # –– Parámetros para las VMs ––
  dns             = "100.100.1.1"
  gateway         = "192.168.1.1"
  network_mask    = "255.255.255.0"
  network_address = "192.168.1.0"

  ar {
    ar_type = "IP4"
    ip4     = "192.168.1.200" # rango que tu router no use por DHCP
    size    = 50              # 200‑249
  }

  tags = {
    environment = "prod"
  }
  template_section {
    name = "VNET"
    elements = {
      SIZE = "24"
      TYPE = "BR"
    }
  }
}


# ###############################################################################
# # 4. CREACIÓN DE DOS VMs USANDO LA IMAGEN Y LA RED PRIVADA
# ###############################################################################

resource "opennebula_virtual_machine" "vm" {
  count = 0

  name        = "virtual-machine-${count.index}"
  description = "VM"
  cpu         = 1
  vcpu        = 1
  memory      = 1024
  group       = "oneadmin"
  permissions = "660"
  context = {
    NETWORK      = "YES"
    SET_HOSTNAME = "$NAME"
    START_SCRIPT = "echo -e '123456\n123456' | passwd root |sudo apt update -y && sudo apt install sshpass -y"
  }
  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "es"
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }
  # Disco principal usando la imagen creada
  disk {
    image_id = opennebula_image.ubuntu_image.id
    size     = 10000
    target   = "vda"
    driver   = "qcow2"
  }
  # Interfaz de red en la red privada, aplicando security group
  nic {
    model           = "virtio"
    network_id      = opennebula_virtual_network.private_net.id
    security_groups = [opennebula_security_group.basic_sg.id]
    dns             = "8.8.8.8"
  }
}
