#!/bin/bash
# ============================================================
# 🚀 Quick Update API Script
# ============================================================
# Updates both repos and starts FastAPI server

set -e

echo "🔄 Updating repositories and starting FastAPI..."

# Update runpod-scripts
cd /workspace/runpod-scripts
echo "📦 Updating runpod-scripts..."
git pull origin main

# Update Chatterbox-Multilingual-TTS
cd /workspace
if [ ! -d "Chatterbox-Multilingual-TTS" ]; then
    echo "📦 Cloning Chatterbox-Multilingual-TTS..."
    git clone https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS.git
else
    echo "📦 Updating Chatterbox-Multilingual-TTS..."
    cd Chatterbox-Multilingual-TTS
    git pull origin main
fi

# Start FastAPI
cd /workspace/runpod-scripts
echo "🚀 Starting FastAPI server..."
bash start_fastapi.sh

