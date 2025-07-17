# OneCloud

El proyecto OneCloud, trata de abordar la implementación de una infraestructura segura y automatizada utilizando Infraestructura como Código (IaC) como Terraform, la plataforma de gestión de máquinas virtuales y contenedores denominada OpenNebula, y tecnologías avanzadas de seguridad como Confidential Computing.

# OneCloud☁️: Monitorización, Automatización y Seguridad

## 📌 Descripción

Este proyecto de Trabajo de Fin de Grado (TFG), titulado **"OneCloud: Monitorización, Automatización y Seguridad"**, ha sido desarrollado por **Alexandru Ionut Stoian** como parte del grado en **Ingeniería Informática** en la **Universitat Oberta de Catalunya (UOC)**.

OneCloud propone una infraestructura segura y automatizada mediante el uso de tecnologías de vanguardia como Terraform, OpenNebula y Confidential Computing, complementadas con herramientas como Ansible, Prometheus y Grafana.

---

## 🎯 Objetivos

- **Objetivo principal**:  
  Desplegar una infraestructura funcional que integre automatización, monitorización y seguridad, garantizando la protección de datos mediante Confidential Computing.

- **Objetivos específicos**:
  - Investigar desafíos en entornos cloud.
  - Analizar y aplicar Terraform, OpenNebula y Confidential Computing.
  - Diseñar una arquitectura lógica y física segura.
  - Automatizar configuración con Ansible.
  - Implementar monitorización con Prometheus y Grafana.
  - Evaluar rendimiento y seguridad del entorno.

---

## 🛠️ Tecnologías empleadas

- **Terraform**: IaC para desplegar y gestionar recursos.
- **OpenNebula**: Plataforma de gestión de máquinas virtuales y contenedores.
- **Confidential Computing**: Protección de datos en uso (Intel SGX).
- **Ansible**: Automatización de tareas de configuración.
- **Prometheus**: Recolección de métricas en tiempo real.
- **Grafana**: Visualización de métricas y alertas.
- **LUKS**: Cifrado de discos.
- **Ubuntu / KVM / LXD**: Infraestructura base y virtualización.

---

## 🧱 Estructura del proyecto

```bash
onecloud/
├── terraform/           # Infraestructura como código
│   ├── main.tf
│   ├── providers.tf
│   ├── versions.tf
│   └── vm_conf_comp_template.tf
├── ansible/             # Playbooks y configuración automatizada
│   ├── playbooks/
│   └── inventory_opennebula.yml
├── grafana_dashboards/  # Paneles personalizados para Grafana
└── README.md
