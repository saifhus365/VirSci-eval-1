# Force amd64 build so it runs on the GPU cluster
FROM --platform=linux/amd64 pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime

# System deps
RUN apt-get update && apt-get install -y \
    curl git build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy repo into container
WORKDIR /workspace
COPY . /workspace

# Upgrade pip
RUN pip install --upgrade pip

# Install project requirements (agentscope pinned here will fail, but that's okay)
RUN pip install --no-cache-dir -r requirements.txt || true

# Install agentscope from its own pyproject.toml (editable mode)
WORKDIR /workspace/agentscope-main
RUN pip install -e .

# Install extra packages not guaranteed to be in agentscope
RUN pip install ollama faiss-gpu

# Back to repo root
WORKDIR /workspace

CMD ["/bin/bash"]
