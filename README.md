# 🚀 Nextcloud Deployment Script (Oracle Cloud ARM + RHEL9 + Podman)

This repository contains a one-shot script to deploy **Nextcloud** on an **Oracle Cloud ARM (A1.Flex)** instance running **RHEL 9**, using **Podman Compose**, with full HTTPS support via Let's Encrypt and DuckDNS.

> 🧠 This was built, debugged, and hardened the hard way—so you don’t have to.

---

## 🧰 Features

- ✅ Deploys Nextcloud, MariaDB, and Redis containers via `podman-compose`
- 🔐 Automatically provisions free HTTPS certificates with Certbot + DuckDNS
- 🧱 Creates systemd units for clean container lifecycle management
- ☁️ Tested on Oracle Cloud (Always Free Tier)

---

## 📦 Requirements

- Oracle Cloud ARM instance (RHEL 9 recommended)
- A DuckDNS domain (free dynamic DNS)
- Public IP with open ports **80** and **443**

---

## 📜 Usage

### 🛠 1. Clone this repository

```bash
git clone https://github.com/qumaralam2012/NextCloud.git
cd NextCloud
