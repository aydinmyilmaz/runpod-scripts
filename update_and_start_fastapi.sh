#!/bin/bash
# ============================================================
# 🚀 Update Chatterbox-Multilingual-TTS Repo and Start FastAPI
# ============================================================
# This script updates the Chatterbox-Multilingual-TTS repo and starts the FastAPI server

set -e

echo "🔄 Updating Chatterbox-Multilingual-TTS repository..."

cd /workspace

# Clone repo if it doesn't exist
if [ ! -d "Chatterbox-Multilingual-TTS" ]; then
    echo "📦 Cloning repository..."
    git clone https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS.git
fi

cd Chatterbox-Multilingual-TTS

# Pull latest changes
echo "⬇️ Pulling latest changes..."
git pull origin main

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "⚠️ Virtual environment not found. Please run deploy_gradio.sh first to set up the environment."
    exit 1
fi

# Activate venv
source venv/bin/activate

# Kill existing FastAPI session if any
tmux kill-session -t fastapi_server 2>/dev/null || true
sleep 2

# Start FastAPI server in tmux
echo "🚀 Starting FastAPI server..."
tmux new-session -d -s fastapi_server bash -c "
    source venv/bin/activate
    export HF_HUB_ENABLE_HF_TRANSFER=1
    export PYTHONPATH=/workspace/Chatterbox-Multilingual-TTS:\$PYTHONPATH
    export PORT=8004
    cd /workspace/Chatterbox-Multilingual-TTS
    python api_server.py 2>&1 | tee /workspace/fastapi.log
"

sleep 3

if tmux has-session -t fastapi_server 2>/dev/null; then
    echo "✅ FastAPI server started in tmux session 'fastapi_server'"
    echo "📋 To view logs: tmux attach -t fastapi_server"
    echo "📋 Or: tail -f /workspace/fastapi.log"
    echo "🌐 API will be available at: http://your-pod-id.runpod.net:8004"
else
    echo "❌ Failed to start. Check: tail -f /workspace/fastapi.log"
    exit 1
fi

