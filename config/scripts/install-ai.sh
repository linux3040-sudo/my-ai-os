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
# 4. Install Ollama for Local LLMs (The standard for local AI in 2026)
# On Fedora 43, we can use the native package or the official install script
curl -fsSL https://ollama.com/install.sh | sh

# 5. Pre-configure Ollama to listen on all interfaces (useful for local network access)
mkdir -p /etc/systemd/system/ollama.service.d
echo -e "[Service]\nEnvironment=\"OLLAMA_HOST=0.0.0.0\"" > /etc/systemd/system/ollama.service.d/override.conf

# 6. Enable the service so your AI is ready the second you log in
systemctl enable ollama
echo "AI configuration complete!"
