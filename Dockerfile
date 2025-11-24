# Use Alpine as the base image
FROM alpine:latest

ARG TERRAFORM_VERSION=1.14.0
ARG HELM_VERSION=3.19.0
ARG VAULT_VERSION=1.21.1

# Set environment variables
ENV PATH="/usr/local/bin:/usr/local/aws-cli/v2/current/bin:/usr/local/istio/bin:$PATH"

# Install dependencies and tools
RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    python3 \
    py3-pip \
    git \
    openssh \
    sshpass \
    jq \
    openssl && \
    \
    # Install AWS CLI
    pip install awscli --break-system-packages && \
    \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    \
    # Install Helm
    curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 && \
    \
    # Install Istio CLI
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.23.0 sh - && \
    mv istio-* /usr/local/istio && \
    \
    # Install Terraform CLI
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        mv terraform /usr/local/bin/ && \
        rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        \
    # Install Vault
    curl -LO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/local/bin/ && \
    rm vault_${VAULT_VERSION}_linux_amd64.zip && \
    # Clean up
    rm -rf /var/cache/apk/* /root/.cache

# Verify installations
RUN helm version && \
    aws --version && \
    kubectl version --client && \
    /usr/local/istio/bin/istioctl version --remote=false --short

# Default shell
CMD ["/bin/bash"]