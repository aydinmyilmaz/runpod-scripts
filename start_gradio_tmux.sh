#!/bin/bash
# ============================================================
# 🚀 Start Gradio App in tmux (Background)
# ============================================================
# Use this to run Gradio in background with logging

cd /workspace/Chatterbox-Multilingual-TTS

# Kill existing session if any
tmux kill-session -t gradio_app 2>/dev/null || true
sleep 2

# Start new session
tmux new-session -d -s gradio_app bash -c "
    source venv/bin/activate
    export HF_HUB_ENABLE_HF_TRANSFER=1
    export PYTHONPATH=/workspace/Chatterbox-Multilingual-TTS:\$PYTHONPATH
    python examples/app.py 2>&1 | tee /workspace/gradio.log
"

sleep 3

if tmux has-session -t gradio_app 2>/dev/null; then
    echo "✅ Gradio app started in tmux session 'gradio_app'"
    echo "📋 To view logs: tmux attach -t gradio_app"
    echo "📋 Or: tail -f /workspace/gradio.log"
else
    echo "❌ Failed to start. Check: tail -f /workspace/gradio.log"
fi

