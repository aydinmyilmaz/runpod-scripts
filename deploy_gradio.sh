#!/bin/bash
# ============================================================
# 🚀 RunPod'da Gradio App Deploy Script
# ============================================================
# Bu script'i RunPod terminalinde çalıştırın
# Mevcut GitHub repo'ya değişiklik yapmaz, sadece local deploy eder

set -e

echo "🚀 Setting up Chatterbox Multilingual TTS - Gradio App"
echo "======================================================"

# 1. Repo'yu clone et
cd /workspace
if [ ! -d "Chatterbox-Multilingual-TTS" ]; then
    echo "📦 Cloning repository..."
    git clone https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS.git
fi
cd Chatterbox-Multilingual-TTS

# 2. Git LFS kurulumu
if ! command -v git-lfs &> /dev/null; then
    echo "📦 Installing git-lfs..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git-lfs
    elif command -v yum &> /dev/null; then
        sudo yum install -y git-lfs
    fi
    git lfs install
fi

# 3. UV kurulumu
if ! command -v uv &> /dev/null; then
    echo "📦 Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# 4. Rust kurulumu (UV için gerekli)
if ! command -v rustc &> /dev/null; then
    echo "📦 Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# 5. Virtual environment oluştur
echo "🐍 Creating virtual environment..."
uv venv --python 3.10 venv
source venv/bin/activate

# 6. Temel paketleri kur
echo "⚡ Installing setuptools..."
uv pip install "setuptools>=65.0.0" --quiet

echo "⚡ Installing hf_transfer..."
uv pip install "hf_transfer>=0.1.0" --quiet

# 7. PyTorch kurulumu
echo "⚡ Installing PyTorch with CUDA..."
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --quiet

# 8. Gradio ve diğer bağımlılıklar
echo "⚡ Installing Gradio..."
uv pip install gradio --quiet

echo "⚡ Installing spaces module..."
uv pip install spaces --quiet

echo "⚡ Installing other dependencies..."
uv pip install -r requirements_fastapi.txt --quiet

# 9. Reference audio dizini
echo "📁 Creating reference_audio directory..."
mkdir -p reference_audio
touch reference_audio/.gitkeep

# 10. Verification
echo ""
echo "🔍 Verifying installation..."
python - <<'EOF'
import torch
try:
    from src.chatterbox.mtl_tts import ChatterboxMultilingualTTS, SUPPORTED_LANGUAGES
    import gradio as gr
    import spaces
    print(f'✅ PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')
    print(f'✅ Chatterbox Multilingual TTS ready!')
    print(f'✅ Supported languages: {len(SUPPORTED_LANGUAGES)} languages')
    print(f'✅ Gradio: {gr.__version__}')
    print(f'✅ Spaces module: Available')
except ImportError as e:
    print(f'⚠️ Import error: {e}')
EOF

echo ""
echo "✅ Installation complete!"
echo ""
echo "🌐 Gradio will run on port 7860 (default)"
echo "   RunPod public endpoint: Configure port 7860 in RunPod settings"
echo ""
echo "🚀 To start Gradio app (run these commands):"
echo "   cd /workspace/Chatterbox-Multilingual-TTS"
echo "   source venv/bin/activate"
echo "   export HF_HUB_ENABLE_HF_TRANSFER=1"
echo "   python examples/app.py"
echo ""
echo "📝 Or run in tmux (background) - copy and paste this entire command:"
echo "   cd /workspace/Chatterbox-Multilingual-TTS && tmux new-session -d -s gradio_app bash -c 'source venv/bin/activate && export HF_HUB_ENABLE_HF_TRANSFER=1 && python examples/app.py 2>&1 | tee /workspace/gradio.log'"
echo ""
echo "⚠️  Note: For public access, modify examples/app.py:"
echo "   Change: demo.launch(mcp_server=True)"
echo "   To: demo.launch(server_name=\"0.0.0.0\", server_port=7860, share=False)"
echo ""
echo "🔍 To check logs:"
echo "   tmux attach -t gradio_app"
echo "   or: tail -f /workspace/gradio.log"

