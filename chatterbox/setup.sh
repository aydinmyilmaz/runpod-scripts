#!/bin/bash
# ============================================================
# 🚀 Chatterbox Multilingual TTS - One-Shot Setup Script
# ============================================================
# This script sets up everything needed to run the FastAPI server
# Run this ONCE when starting a new RunPod instance
#
# Usage:
#   cd /workspace
#   git clone https://github.com/aydinmyilmaz/runpod-scripts.git
#   cd runpod-scripts
#   bash setup.sh

set -e

echo "🚀 Chatterbox Multilingual TTS - Setup"
echo "======================================"
echo ""

# ============================================================
# 1. Clone Repository
# ============================================================

echo "📦 Step 1/6: Cloning Chatterbox-Multilingual-TTS repository..."
cd /workspace

if [ ! -d "Chatterbox-Multilingual-TTS" ]; then
    git clone https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS.git
    echo "✅ Repository cloned"
else
    echo "ℹ️  Repository already exists. Pulling latest changes..."
    cd Chatterbox-Multilingual-TTS
    git pull origin main
    cd ..
    echo "✅ Repository updated"
fi

cd Chatterbox-Multilingual-TTS

# ============================================================
# 2. Install UV (Python package manager)
# ============================================================

echo ""
echo "⚡ Step 2/6: Installing UV..."

if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✅ UV installed"
else
    echo "ℹ️  UV already installed"
fi

# ============================================================
# 3. Install Rust (required for UV)
# ============================================================

echo ""
echo "🦀 Step 3/6: Installing Rust..."

if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    export PATH="$HOME/.cargo/bin:$PATH"
    echo "✅ Rust installed"
else
    echo "ℹ️  Rust already installed"
    source "$HOME/.cargo/env" 2>/dev/null || true
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ============================================================
# 4. Create Virtual Environment
# ============================================================

echo ""
echo "🐍 Step 4/6: Creating virtual environment..."

if [ ! -d "venv" ]; then
    uv venv --python 3.10 venv
    echo "✅ Virtual environment created"
else
    echo "ℹ️  Virtual environment already exists"
fi

source venv/bin/activate

# ============================================================
# 5. Install Dependencies
# ============================================================

echo ""
echo "📚 Step 5/6: Installing dependencies..."
echo "   This may take a few minutes..."

# Install setuptools first (required for pkg_resources)
echo "   → Installing setuptools..."
uv pip install "setuptools>=65.0.0" --quiet

# Install hf_transfer (for fast Hugging Face downloads)
echo "   → Installing hf_transfer..."
uv pip install "hf_transfer>=0.1.0" --quiet

# Install PyTorch with CUDA
echo "   → Installing PyTorch with CUDA..."
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --quiet

# Install all other dependencies
echo "   → Installing other dependencies..."
uv pip install -r requirements_fastapi.txt --quiet

echo "✅ Dependencies installed"

# ============================================================
# 6. Create Reference Audio Directory
# ============================================================

echo ""
echo "📁 Step 6/6: Creating reference_audio directory..."

mkdir -p reference_audio
touch reference_audio/.gitkeep

echo "✅ Reference audio directory created"

# ============================================================
# ✅ Verification
# ============================================================

echo ""
echo "🧪 Verifying installation..."

python - <<'EOF'
import torch
try:
    from src.chatterbox.mtl_tts import ChatterboxMultilingualTTS, SUPPORTED_LANGUAGES
    print(f'✅ PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')
    print(f'✅ Chatterbox Multilingual TTS ready!')
    print(f'✅ Supported languages: {len(SUPPORTED_LANGUAGES)} languages')
except ImportError as e:
    print(f'⚠️ Import error: {e}')
    print('⚠️ Some dependencies may be missing')
    exit(1)
EOF

# ============================================================
# 🌐 RunPod Auto URL Detection & External Service Update
# ============================================================

PORT=8004
STREAMLIT_UPDATE_URL="http://194.163.145.174:8505/update_tts_url"
SESSION="chatterbox_api"
LOG_FILE="/workspace/fastapi.log"

echo ""
echo "🔍 Auto-detecting RunPod server URL..."

# Method 1: Use pod ID from hostname
POD_ID=$(hostname)
TTS_URL="https://${POD_ID}-${PORT}.proxy.runpod.net"

# Method 2: Fallback to env vars
if [[ -n "${RUNPOD_POD_ID:-}" ]]; then
    POD_ID="${RUNPOD_POD_ID}"
    TTS_URL="https://${POD_ID}-${PORT}.proxy.runpod.net"
fi

API_URL="${TTS_URL}/tts"
GENERATE_URL="${TTS_URL}/generate"
UI_URL="${TTS_URL}"
DOCS_URL="${TTS_URL}/docs"

echo "✅ Auto-detected URLs:"
echo "   🖥️  Web UI: ${UI_URL}"
echo "   📚 API Docs: ${DOCS_URL}"
echo "   🔌 Main API Endpoint: ${API_URL}"
echo "   🆕 Alias API Endpoint: ${GENERATE_URL}"

echo ""
echo "📡 Notifying external service..."
curl -s -X POST -H 'Content-Type: application/json' \
     -d "{\"tts_url\":\"$API_URL\"}" \
     "$STREAMLIT_UPDATE_URL" \
     && echo "✅ External service notified successfully!" \
     || echo "⚠️  Failed to update external service (continuing anyway)"

# ============================================================
# 🎉 Setup Complete
# ============================================================

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "📋 Next Steps:"
echo ""
echo "   To start the FastAPI server:"
echo "   cd /workspace/runpod-scripts"
echo "   bash start_api.sh"
echo ""
echo "   Or restart after updates:"
echo "   bash restart_api.sh"
echo ""
echo "🌐 The API will run on port 8004"
echo "   Configure port 8004 in RunPod settings for public access"
echo ""
echo "🌐 Server URLs:"
echo "   • API Docs: ${DOCS_URL}"
echo "   • Main /tts: ${API_URL}"
echo "   • Alias /generate: ${GENERATE_URL}"
echo ""

