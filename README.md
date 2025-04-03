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
🧾 2. Review & Edit the Script
Open the script:

bash
Copy
Edit
nano setup-nextcloud.sh
Replace any placeholders:

YOUR_DUCKDNS_DOMAIN

YOUR_EMAIL@example.com (used for Let's Encrypt)

Update passwords if desired

🔒 Ensure no sensitive tokens are hardcoded before sharing.

▶️ 3. Run the Script
Make it executable and run:

bash
Copy
Edit
chmod +x setup-nextcloud.sh
./setup-nextcloud.sh
This will:

Install podman-compose

Configure your containers

Register HTTPS certs with Certbot (via DuckDNS)

Start and persist your containers via systemd

🌐 Access
Local access: http://localhost:8080

External HTTPS: https://your-subdomain.duckdns.org

🔁 Renewing SSL Certs
The script adds a cron job to auto-renew your Let's Encrypt certificate:

bash
Copy
Edit
0 3 * * * /usr/local/bin/certbot renew --quiet && systemctl reload nginx
💡 Tips
🚨 Always double-check config/config.php and add your DuckDNS domain to trusted_domains

✅ Use a firewall rule to open ports 80/443 in your Oracle Cloud dashboard

🙏 Credits
Nextcloud

Podman Team

DuckDNS

Let's Encrypt (Certbot)

Oracle Cloud Free Tier ❤️

📄 License
MIT License – feel free to fork, enhance, and deploy.

Happy clouding! ☁️📦
