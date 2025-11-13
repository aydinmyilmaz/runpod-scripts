#!/bin/bash
# ============================================================
# 🚀 Start FastAPI Server (using Gradio app's working code)
# ============================================================
# This uses api_server.py which uses the same code as the working Gradio app

cd /workspace/Chatterbox-Multilingual-TTS

# Kill existing session if any
tmux kill-session -t fastapi_server 2>/dev/null || true
sleep 2

# Start FastAPI server in tmux
tmux new-session -d -s fastapi_server bash -c "
    source venv/bin/activate
    export HF_HUB_ENABLE_HF_TRANSFER=1
    export PYTHONPATH=/workspace/Chatterbox-Multilingual-TTS:\$PYTHONPATH
    export PORT=8004
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
fi

