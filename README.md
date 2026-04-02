# 🚀 DevOps Practice Project — 1-Hour Session Guide

**Stack:** Python Flask · Docker · Terraform · Ansible · Jenkins · Prometheus · Grafana · AWS EC2

---

## 📁 Project Structure

```
devops-practice-project/
├── app/
│   ├── app.py                  # Flask application
│   └── requirements.txt        # Python dependencies
├── docker/
│   └── Dockerfile              # Container definition
├── terraform/
│   └── main.tf                 # AWS EC2 + Security Group
├── ansible/
│   ├── install_docker.yml      # Server setup playbook
│   └── inventory.ini           # Target server IP
├── monitoring/
│   └── prometheus.yml          # Prometheus scrape config
├── ci-cd/
│   └── Jenkinsfile             # Jenkins pipeline
└── README.md
```

---

## ✅ Before the Session — Checklist

### Your machine must have installed:
- [ ] Docker
- [ ] Terraform
- [ ] AWS CLI (`aws configure` done with your IAM key)
- [ ] Ansible (`pip install ansible`)
- [ ] Git
- [ ] Jenkins (running locally or on a server)

### Accounts needed:
- [ ] AWS account (with IAM user + admin access)
- [ ] GitHub account (repo ready)
- [ ] Docker Hub account

### AWS pre-setup:
- [ ] EC2 key pair created in `us-east-1` — download the `.pem` file
- [ ] Default VPC exists (it does by default)
- [ ] Note your key pair name — you'll put it in `terraform/main.tf`

---

## 🕐 1-Hour Session Flow

### ⏱ Minutes 0–10 | Explore the App Locally

```bash
# Clone / open the project
cd devops-practice-project

# Run the Flask app locally (optional quick test)
cd app
pip install -r requirements.txt
python app.py
# Visit: http://localhost:5000
```

---

### ⏱ Minutes 10–20 | Provision AWS with Terraform

1. Open `terraform/main.tf`
2. Update `key_name` to your actual AWS key pair name
3. Run:

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

4. Copy the `server_public_ip` from the output — you'll use it everywhere.

---

### ⏱ Minutes 20–30 | Configure Server with Ansible

1. Open `ansible/inventory.ini`
2. Replace `EC2_PUBLIC_IP` with the IP from Terraform
3. Open `monitoring/prometheus.yml` — also replace `EC2_PUBLIC_IP`
4. Open `ansible/install_docker.yml` — update `app_image` with your Docker Hub username
5. Run:

```bash
cd ansible
ansible-playbook -i inventory.ini install_docker.yml
```

> This installs Docker, Node Exporter, and starts Prometheus + Grafana on the server.

---

### ⏱ Minutes 30–40 | Build & Push Docker Image

```bash
# From project root
docker build -f docker/Dockerfile -t your-dockerhub-username/devops-practice-app:latest .

# Login and push
docker login
docker push your-dockerhub-username/devops-practice-app:latest
```

Test the app is running:
```bash
curl http://EC2_PUBLIC_IP:5000/health
```

---

### ⏱ Minutes 40–55 | Jenkins CI/CD Pipeline

1. Open Jenkins → **New Item** → **Pipeline**
2. Under Pipeline → Definition: select **"Pipeline script from SCM"**
3. Point it to your GitHub repo
4. Set Script Path to: `ci-cd/Jenkinsfile`
5. Add credentials in Jenkins:
   - `dockerhub-credentials` — Docker Hub login
   - `ec2-ssh-key` — your `.pem` file (SSH private key type)
6. Update `EC2_IP` and `DOCKERHUB_USER` in the Jenkinsfile
7. Click **Build Now** and watch each stage run ✅

---

### ⏱ Minutes 55–60 | Monitoring with Prometheus + Grafana

**Prometheus:**
```
http://EC2_PUBLIC_IP:9090
```
- Go to **Status → Targets** — you should see node_exporter as UP
- Try a query: `node_memory_MemAvailable_bytes`

**Grafana:**
```
http://EC2_PUBLIC_IP:3000
Login: admin / admin
```
- Add data source → Prometheus → URL: `http://localhost:9090`
- Import dashboard ID **1860** (Node Exporter Full) — instant server metrics!

---

## 🧹 Cleanup (After Session)

```bash
cd terraform
terraform destroy -auto-approve
```

> This deletes the EC2 instance and security group so you don't get charged.

---

## 🔑 Quick Reference — Key URLs

| Service | URL |
|---|---|
| Flask App | `http://EC2_PUBLIC_IP:5000` |
| App Health | `http://EC2_PUBLIC_IP:5000/health` |
| Prometheus | `http://EC2_PUBLIC_IP:9090` |
| Grafana | `http://EC2_PUBLIC_IP:3000` |
| Node Exporter | `http://EC2_PUBLIC_IP:9100/metrics` |

---

## ⚠️ Things to Replace Before the Session

| File | What to change |
|---|---|
| `terraform/main.tf` | `key_name = "your-key-pair-name"` |
| `ansible/inventory.ini` | `EC2_PUBLIC_IP` |
| `ansible/install_docker.yml` | `your-dockerhub-username` |
| `monitoring/prometheus.yml` | `EC2_PUBLIC_IP` (x2) |
| `ci-cd/Jenkinsfile` | `DOCKERHUB_USER` and `EC2_IP` |
# sheraz-devops
