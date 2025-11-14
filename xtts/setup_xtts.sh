#!/bin/bash
# ============================================================
# 🚀 Coqui TTS (XTTS v2) - Setup Script
# ============================================================
# Sets up separate virtual environment and dependencies for XTTS v2
# Runs on port 8005 to avoid conflicts with Chatterbox TTS (port 8004)
#
# Usage:
#   cd /workspace/runpod-scripts
#   bash setup_xtts.sh

set -e

echo "🚀 Coqui TTS (XTTS v2) - Setup"
echo "======================================"
echo ""

PROJECT_DIR="/workspace/Chatterbox-Multilingual-TTS"

# Check if main repo exists
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "📦 Cloning Chatterbox-Multilingual-TTS repository..."
    cd /workspace
    git clone https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS.git
else
    echo "ℹ️  Repository already exists"
fi

cd "$PROJECT_DIR"

# Check if UV is installed
if ! command -v uv &> /dev/null; then
    echo "⚡ Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
    echo "🦀 Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env" 2>/dev/null || true
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Create separate virtual environment for XTTS
echo ""
echo "🐍 Creating separate virtual environment for XTTS..."

if [ ! -d "venv_xtts" ]; then
    uv venv --python 3.10 venv_xtts
    echo "✅ Virtual environment created"
else
    echo "ℹ️  Virtual environment already exists"
fi

source venv_xtts/bin/activate

# Install dependencies
echo ""
echo "📚 Installing dependencies..."
echo "   This may take a few minutes..."

# Install setuptools first
echo "   → Installing setuptools..."
uv pip install "setuptools>=65.0.0" --quiet

# Install PyTorch with CUDA
echo "   → Installing PyTorch with CUDA..."
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --quiet

# Install all other dependencies
echo "   → Installing other dependencies..."
uv pip install -r requirements_xtts.txt --quiet

echo "✅ Dependencies installed"

# Create reference audio directory (same as Chatterbox TTS for compatibility)
echo ""
echo "📁 Creating reference_audio directory..."
mkdir -p reference_audio
touch reference_audio/.gitkeep
echo "✅ Reference audio directory created"

# Verification
echo ""
echo "🧪 Verifying installation..."

python - <<'EOF'
import torch
try:
    from TTS.api import TTS
    print(f'✅ PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')
    print(f'✅ Coqui TTS package available')
    print(f'✅ Installation complete!')
except ImportError as e:
    print(f'⚠️ Import error: {e}')
    print('⚠️ Some dependencies may be missing')
    exit(1)
EOF

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "📋 Next Steps:"
echo ""
echo "   To start the XTTS API server:"
echo "   cd /workspace/runpod-scripts"
echo "   bash start_xtts.sh"
echo ""
echo "🌐 The API will run on port 8005"
echo "   Configure port 8005 in RunPod settings for public access"
echo ""
echo "📝 Note: This API runs separately from Chatterbox TTS API (port 8004)"
echo "   Both can run simultaneously on the same pod"
echo ""

