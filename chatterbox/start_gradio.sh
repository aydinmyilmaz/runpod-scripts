#!/bin/bash
# ============================================================
# 🚀 Quick Start Script for Gradio App
# ============================================================
# Use this after pod restart to quickly start Gradio app

cd /workspace/Chatterbox-Multilingual-TTS
source venv/bin/activate
export HF_HUB_ENABLE_HF_TRANSFER=1
export PYTHONPATH=/workspace/Chatterbox-Multilingual-TTS:$PYTHONPATH
python examples/app.py

