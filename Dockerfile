# ==============================
# URDFormer Dockerfile
# ==============================
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# System dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git wget curl unzip vim \
    libgl1-mesa-glx libglib2.0-0 \
    software-properties-common \
    build-essential cmake \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update && apt-get install -y \
    python3.9 python3.9-dev python3.9-distutils python3.9-venv \
    && rm -rf /var/lib/apt/lists/*

# Make python3.9 the default
RUN ln -sf /usr/bin/python3.9 /usr/bin/python

# Install pip for Python 3.9
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

# ------------------------------
# Install PyTorch (CUDA 11.8 build)
# ------------------------------
RUN pip install --upgrade pip
RUN pip install torch==2.1.0+cu118 torchvision==0.16.0+cu118 torchaudio==2.1.0 \
    --index-url https://download.pytorch.org/whl/cu118

# ------------------------------
# Install URDFormer dependencies
# ------------------------------
WORKDIR /workspace
# RUN git clone https://github.com/WEIRDLabUW/urdformer.git
# WORKDIR /workspace/urdformer

COPY requirements.txt .

# Install base requirements
RUN pip install -r requirements.txt

# Install openmim + mmcv/mmengine for GroundingDINO
RUN pip install -U openmim
RUN mim install mmengine
RUN mim install "mmcv>=2.0.0,<2.2.0"

# Install GroundingDINO (editable mode)
# WORKDIR /workspace/urdformer/grounding_dino
# RUN pip install -v -e .

# WORKDIR /workspace/urdformer

# # ------------------------------
# # Environment setup
# # ------------------------------
# ENV PATH=/workspace/urdformer:$PATH

# Default command
CMD ["/bin/bash"]