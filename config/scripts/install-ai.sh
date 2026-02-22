#!/usr/bin/env bash

# Stop on errors
set -oue pipefail

echo "Starting AI-specific configuration..."

# 1. Enable NVIDIA support if the toolkit was installed via RPM-ostree
if [ -f /usr/bin/nvidia-container-toolkit ]; then
    echo "Configuring NVIDIA Container Toolkit..."
    nvidia-container-toolkit --generate-config
fi

# 2. Pre-pull common AI runtimes (Optional, saves time on first boot)
# Note: Since this runs during image build, it helps bake in dependencies.
echo "Setting up Podman for AI workloads..."
systemctl enable podman.socket

# 3. Add any custom AI repos (e.g., for specific LLM tools)
# Example: curl -sS https://example.ai/install.sh | bash

echo "AI configuration complete!"