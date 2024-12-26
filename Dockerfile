# Use Alpine as the base image
FROM alpine:latest

# Set environment variables to avoid prompts
ENV PATH="/usr/local/bin:/usr/local/aws-cli/v2/current/bin:/usr/local/istio/bin:$PATH"

# Install dependencies and tools
RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    python3 \
    py3-pip \
    git \
    openssl && \
    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
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
