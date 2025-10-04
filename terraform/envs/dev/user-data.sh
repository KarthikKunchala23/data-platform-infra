#!/bin/bash
set -e

# Update system
sudo apt-get update -y && sudo apt-get upgrade -y

echo "=== Installing dependencies ==="
sudo apt-get install -y unzip curl wget jq git

# --------------------------------------------------
# Install AWS CLI v2
# --------------------------------------------------
echo "=== Installing AWS CLI v2 ==="
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version

# --------------------------------------------------
# Install kubectl (latest stable)
# --------------------------------------------------
echo "=== Installing kubectl ==="
KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --short

# --------------------------------------------------
# Install k9s (latest release)
# --------------------------------------------------
echo "=== Installing k9s ==="
LATEST_K9S=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
curl -Lo k9s_Linux_amd64.tar.gz "https://github.com/derailed/k9s/releases/download/${LATEST_K9S}/k9s_Linux_amd64.tar.gz"
tar -xzf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
k9s version

# --------------------------------------------------
# Add useful aliases
# --------------------------------------------------
echo "=== Configuring bash aliases ==="
cat <<EOF >> /home/ubuntu/.bashrc

# Handy Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods -A'
alias kgs='kubectl get svc -A'
alias kctx='kubectl config current-context'

# AWS CLI short aliases
alias awsprofile='aws configure list'
alias awswho='aws sts get-caller-identity'
EOF

# --------------------------------------------------
# Permissions and cleanup
# --------------------------------------------------
chown ubuntu:ubuntu /home/ubuntu/.bashrc
rm -rf /tmp/awscliv2.zip /tmp/aws

echo "✅ Setup complete: AWS CLI, kubectl, and k9s installed."
