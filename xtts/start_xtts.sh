#!/bin/bash
# ============================================================
# 🚀 Start Coqui TTS (XTTS v2) API Server
# ============================================================
# Separate API running on port 8005
# Quick start script - assumes setup_xtts.sh has already been run
#
# Usage:
#   bash start_xtts.sh

set -e

PROJECT_DIR="/workspace/Chatterbox-Multilingual-TTS"
SESSION="coqui_xtts_api"
LOG_FILE="/workspace/xtts.log"

echo "🚀 Starting Coqui TTS (XTTS v2) API Server..."
echo ""

# Check if repo exists
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "❌ Chatterbox-Multilingual-TTS repository not found!"
    echo "   Please run: bash setup_xtts.sh first"
    exit 1
fi

# Check if venv exists
if [ ! -d "$PROJECT_DIR/venv_xtts" ]; then
    echo "❌ Virtual environment not found!"
    echo "   Please run: bash setup_xtts.sh first"
    exit 1
fi

# Kill existing session if any
tmux kill-session -t "$SESSION" 2>/dev/null || true
sleep 2

# Start XTTS API server in tmux
echo "🎬 Starting server in tmux session: $SESSION"
tmux new-session -d -s "$SESSION" bash -c "
    source '$PROJECT_DIR/venv_xtts/bin/activate'
    export PYTHONPATH=$PROJECT_DIR:\$PYTHONPATH
    export PORT=8005
    cd '$PROJECT_DIR'
    python api_xtts.py 2>&1 | tee '$LOG_FILE'
"

sleep 5

if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo ""
    echo "✅ Coqui TTS API server started successfully!"
    echo ""
    echo "📋 Useful commands:"
    echo "   • View logs: tail -f $LOG_FILE"
    echo "   • Attach to session: tmux attach -t $SESSION"
    echo "   • Stop server: tmux kill-session -t $SESSION"
    echo ""
    echo "🌐 API Endpoints:"
    echo "   • POST /tts - Generate TTS audio"
    echo "   • POST /upload_speaker - Upload reference speaker audio"
    echo "   • GET /speaker_files - List speaker files"
    echo "   • GET /languages - Get supported languages"
    echo "   • GET /health - Health check"
    echo "   • GET /docs - API documentation"
    echo ""
    echo "🌐 Server URL: http://your-pod-id.runpod.net:8005"
    echo "   Configure port 8005 in RunPod settings for public access"
else
    echo ""
    echo "❌ Failed to start server"
    echo "📝 Check logs: tail -f $LOG_FILE"
    exit 1
fi

