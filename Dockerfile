# Use Alpine as the base image
FROM alpine:latest

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
    curl -LO https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.12.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-v3.12.0-linux-amd64.tar.gz linux-amd64 && \
    \
    # Install Istio CLI
    curl -L https://istio.io/downloadIstio | sh - && \
    mv istio-* /usr/local/istio && \
    \
    # Install Terraform CLI
    curl -LO https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip && \
        unzip terraform_1.11.4_linux_amd64.zip && \
        mv terraform /usr/local/bin/ && \
        rm terraform_1.11.4_linux_amd64.zip && \
        \

    # Clean up
    rm -rf /var/cache/apk/* /root/.cache

# Verify installations
RUN helm version && \
    aws --version && \
    kubectl version --client && \
    /usr/local/istio/bin/istioctl version

# Default shell
CMD ["/bin/bash"]
