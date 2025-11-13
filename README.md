# RunPod Deployment Scripts

Simple scripts to deploy and manage Chatterbox Multilingual TTS FastAPI server on RunPod.

## 🚀 Quick Start (New RunPod Instance)

**One command setup:**

```bash
cd /workspace
git clone https://github.com/aydinmyilmaz/runpod-scripts.git
cd runpod-scripts
bash setup.sh
bash start_api.sh
```

That's it! The API will be running on port 8004.

## 📋 Scripts

### Main Scripts

- **`setup.sh`** - One-shot setup script. Run this ONCE when starting a new RunPod instance.
  - Clones the repository
  - Installs UV, Rust, Python dependencies
  - Creates virtual environment
  - Sets up everything needed

- **`start_api.sh`** - Start the FastAPI server (assumes setup is done)
  - Starts the server in a tmux session
  - Server runs on port 8004

- **`restart_api.sh`** - Restart the server after updates
  - Pulls latest changes from GitHub
  - Restarts the server

### Optional Scripts

- **`start_gradio.sh`** - Start Gradio app (foreground)
- **`start_gradio_tmux.sh`** - Start Gradio app (background in tmux)
- **`deploy_gradio.sh`** - Full setup for Gradio app (if you want Gradio instead of FastAPI)

### Coqui TTS (XTTS v2) Scripts

- **`setup_xtts.sh`** - Setup Coqui TTS (XTTS v2) API - creates separate venv and installs dependencies
- **`start_xtts.sh`** - Start Coqui TTS API server on port 8005
- **Note**: XTTS API runs on port 8005 and can coexist with Chatterbox TTS API (port 8004)

## 🔧 Usage Examples

### First Time Setup

```bash
cd /workspace
git clone https://github.com/aydinmyilmaz/runpod-scripts.git
cd runpod-scripts
bash setup.sh          # One-time setup
bash start_api.sh      # Start the server
```

### After Pod Restart

```bash
cd /workspace/runpod-scripts
bash start_api.sh      # Just start the server (setup already done)
```

### After Code Updates

```bash
cd /workspace/runpod-scripts
bash restart_api.sh    # Pulls updates and restarts
```

## 🌐 API Endpoints

Once running, the API is available at `http://your-pod-id.runpod.net:8004`:

- **POST /tts** - Generate TTS audio
- **POST /upload_reference** - Upload reference audio files
- **GET /get_reference_files** - List uploaded reference files
- **GET /get_predefined_voices** - List predefined voices
- **GET /languages** - Get supported languages
- **GET /health** - Health check
- **GET /docs** - Interactive API documentation

## 📝 Useful Commands

```bash
# View server logs
tail -f /workspace/fastapi.log

# Attach to tmux session
tmux attach -t chatterbox_api

# Stop server
tmux kill-session -t chatterbox_api

# Check if server is running
tmux has-session -t chatterbox_api && echo "Running" || echo "Stopped"
```

## 🔍 Troubleshooting

**Server won't start:**
- Make sure you ran `setup.sh` first
- Check logs: `tail -f /workspace/fastapi.log`
- Verify virtual environment exists: `ls /workspace/Chatterbox-Multilingual-TTS/venv`

**Port 8004 not accessible:**
- Configure port 8004 in RunPod pod settings
- Check RunPod network settings

**Import errors:**
- Run `bash setup.sh` again to reinstall dependencies
- Make sure you're using Python 3.10

## 📚 More Information

- **Main repository**: https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS
- **API documentation**: http://your-pod-id.runpod.net:8004/docs
- **[Official Multilingual Documentation](https://chatterboxtts.com/docs/multilingual)** - Complete multilingual TTS guide with API reference, examples, and best practices
- **[Hugging Face Space Demo](https://huggingface.co/spaces/ResembleAI/Chatterbox-Multilingual-TTS)** - Test the model interactively in your browser
