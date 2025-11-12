# NGINX Reverse Proxy with SSL – Automated Deployment

This project demonstrates how to automate the deployment of a simple web application (`linux_tweet_app`) behind an NGINX reverse proxy with HTTPS using Let's Encrypt certificates. The deployment is fully automated using **Ansible** and **Docker Compose**.

---

## Overview

The solution consists of:

1. **linux_tweet_app** – a simple web application based on NGINX.
2. **NGINX** – reverse proxy listening on ports 80 (HTTP) and 443 (HTTPS). HTTP traffic is redirected to HTTPS.
3. **Certbot** – handles certificate generation. In local environments, it may fail, but it works on a real domain.
4. **Ansible** – automates package installation, Docker installation, repository cloning, image building, and Docker Compose deployment.

---

## Deployment Flow

```text
+----------------+      HTTP/HTTPS       +-----------------+
|                |---------------------> |                 |
| Client Browser |                       |      NGINX      |
|                |<--------------------- |  Reverse Proxy  |
+----------------+      Redirects        +-----------------+
                                       /       \
                                      /         \
                        +----------------+   +-----------------+
                        | linux_tweet_app|   |   Certbot       |
                        +----------------+   +-----------------+
```

---

## Prerequisites

- Ubuntu or similar Linux.
- Ansible.
- Docker Engine & Docker Compose (installed automatically by playbook).
- Internet connection (for pulling Docker images and Certbot).

---

## How to Deploy

### 1. Clone the Repository

```bash
git clone https://github.com/dilox/reverse-nginx-example
cd reverse-nginx-example
```

### 2. Run Ansible Playbook

```bash
ansible-playbook -i inventory.ini playbook.yaml -K
```

- `-K` prompts for your sudo password.
- This will:
  - Install system packages.
  - Install Docker CE & Docker Compose.
  - Clone and build `linux_tweet_app`.
  - Add current user to the Docker group (if needed).
  - Start Docker Compose for NGINX, linux_tweet_app, and Certbot.

---

### 3. Verify Deployment

- Check Docker Compose services:

```bash
docker compose ps
```

- Test NGINX reverse proxy (HTTP redirects to HTTPS):

```bash
curl -Lk http://localhost
curl -Lk https://localhost
```

---

### 4. Stop Services

```bash
docker compose down
```

---

### Notes

- The `certbot` container will fail locally because a domain and/or a public ip are needed. *It needs to be tested when this conditions will be satisfied*
- Self-signed certificates can be generated locally for testing purposes using `generate_cert.sh`.
- Docker Compose automatically rebuilds the app if the source code changes.
- Lets encrypt expires after 90 days, to renew certificates
```bash
docker compose run --rm certbot renew

docker compose exec nginx nginx -s reload
```

### File Structure

```
reverse_nginx_example/
├── playbook.yaml
├── inventory.ini
├── docker-compose.yaml
├── nginx.conf
├── generate_cert.sh
└── linux_tweet_app/   # cloned by Ansible
```

---

### Justification of Tools

- **Ansible**: Automates system setup, Docker installation, and deployment. Ensures reproducibility and idempotency.
- **Docker & Docker Compose**: Simplifies deployment and management of the web app, NGINX, and Certbot.
- **Certbot**: Automates certificate generation for HTTPS.

---

