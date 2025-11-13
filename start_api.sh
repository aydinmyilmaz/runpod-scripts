#!/bin/bash
# ============================================================
# 🚀 Start FastAPI Server
# ============================================================
# Quick start script - assumes setup.sh has already been run
#
# Usage:
#   bash start_api.sh

set -e

PROJECT_DIR="/workspace/Chatterbox-Multilingual-TTS"
SESSION="chatterbox_api"
LOG_FILE="/workspace/fastapi.log"

echo "🚀 Starting FastAPI Server..."
echo ""

# Check if repo exists
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "❌ Chatterbox-Multilingual-TTS repository not found!"
    echo "   Please run: bash setup.sh first"
    exit 1
fi

# Check if venv exists
if [ ! -d "$PROJECT_DIR/venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "   Please run: bash setup.sh first"
    exit 1
fi

# Kill existing session if any
tmux kill-session -t "$SESSION" 2>/dev/null || true
sleep 2

# Start FastAPI server in tmux
echo "🎬 Starting server in tmux session: $SESSION"
tmux new-session -d -s "$SESSION" bash -c "
    source '$PROJECT_DIR/venv/bin/activate'
    export HF_HUB_ENABLE_HF_TRANSFER=1
    export PYTHONPATH=$PROJECT_DIR:\$PYTHONPATH
    export PORT=8004
    cd '$PROJECT_DIR'
    python api_server.py 2>&1 | tee '$LOG_FILE'
"

sleep 5

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo ""
    echo "✅ FastAPI server started successfully!"
    echo ""
    echo "📋 Useful commands:"
    echo "   • View logs: tail -f $LOG_FILE"
    echo "   • Attach to session: tmux attach -t $SESSION"
    echo "   • Stop server: tmux kill-session -t $SESSION"
    echo ""
    echo "🌐 API Endpoints:"
    echo "   • POST /tts - Generate TTS audio"
    echo "   • POST /upload_reference - Upload reference audio"
    echo "   • GET /get_reference_files - List reference files"
    echo "   • GET /health - Health check"
    echo "   • GET /docs - API documentation"
    echo ""
    echo "🌐 Server URL: http://your-pod-id.runpod.net:8004"
else
    echo ""
    echo "❌ Failed to start server"
    echo "📝 Check logs: tail -f $LOG_FILE"
    exit 1
fi

