#!/bin/bash
# ============================================================
# 🔄 Restart FastAPI Server
# ============================================================
# Restarts the FastAPI server after updates
#
# Usage:
#   bash restart_api.sh

set -e

PROJECT_DIR="/workspace/Chatterbox-Multilingual-TTS"
SESSION="chatterbox_api"
LOG_FILE="/workspace/fastapi.log"

echo "🔄 Restarting FastAPI Server..."
echo ""

# Update repository
if [ -d "$PROJECT_DIR/.git" ]; then
    echo "📦 Updating repository..."
    cd "$PROJECT_DIR"
    git pull origin main || echo "⚠️  Could not pull latest changes (continuing anyway)"
    cd - > /dev/null
    echo "✅ Repository updated"
else
    echo "⚠️  Repository not found, skipping update"
fi

# Kill existing session
echo "🧹 Stopping existing server..."
tmux kill-session -t "$SESSION" 2>/dev/null && echo "   ✅ Stopped" || echo "   ℹ️  No existing session"
sleep 2

# Start new session
echo "🚀 Starting server..."
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
    echo "✅ Server restarted successfully!"
    echo ""
    echo "📋 Useful commands:"
    echo "   • View logs: tail -f $LOG_FILE"
    echo "   • Attach to session: tmux attach -t $SESSION"
    echo ""
else
    echo ""
    echo "❌ Failed to restart"
    echo "📝 Check logs: tail -f $LOG_FILE"
    exit 1
fi

