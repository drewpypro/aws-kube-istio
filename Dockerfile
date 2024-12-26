# Use Alpine as the base image
FROM alpine:latest

# Set environment variables to avoid prompts
ENV PATH="/usr/local/istio/bin:${PATH}"

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    python3 \
    py3-pip \
    git \
    openssl && \
    # Install AWS CLI
    pip install awscli && \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/ && \
    # Install Istio CLI
    curl -L https://istio.io/downloadIstio | sh - && \
    mv istio-* /usr/local/istio && \
    # Clean up
    rm -rf /var/cache/apk/* /root/.cache

# Default shell
CMD ["/bin/bash"]
