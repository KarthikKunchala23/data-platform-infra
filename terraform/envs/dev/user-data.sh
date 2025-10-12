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
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl
kubectl version --client

# --------------------------------------------------
# Install k9s (latest release)
# --------------------------------------------------
echo "=== Installing k9s ==="
# Get the latest version
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)

# Download and extract
curl -L -o k9s.tar.gz https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
tar -xzf k9s.tar.gz

# Move binary to PATH
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

echo "Setup complete: AWS CLI, kubectl, and k9s installed."
