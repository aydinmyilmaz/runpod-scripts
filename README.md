# RunPod Deployment Scripts

Simple scripts to deploy and manage Chatterbox Multilingual TTS FastAPI server on RunPod.

## 🚀 Quick Start (New RunPod Instance)

### Chatterbox TTS API (Port 8004)

```bash
cd /workspace
git clone https://github.com/aydinmyilmaz/runpod-scripts.git
cd runpod-scripts/chatterbox
bash setup.sh
bash start_api.sh
```

### Coqui TTS (XTTS v2) API (Port 8005)

```bash
cd /workspace/runpod-scripts/xtts
bash setup_xtts.sh
bash start_xtts.sh
```

**Note**: Both APIs can run simultaneously on the same pod!

## 📋 Scripts Organization

Scripts are organized into two folders:

### 📁 `chatterbox/` - Chatterbox TTS API (Port 8004)

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

### 📁 `xtts/` - Coqui TTS (XTTS v2) API (Port 8005)

- **`setup_xtts.sh`** - Setup Coqui TTS (XTTS v2) API
  - Creates separate venv (`venv_xtts`)
  - Installs XTTS dependencies
  - Avoids dependency conflicts with Chatterbox TTS

- **`start_xtts.sh`** - Start Coqui TTS API server
  - Starts server on port 8005
  - Can coexist with Chatterbox TTS API

### 📁 Root Level - Optional Scripts

- **`start_gradio.sh`** - Start Gradio app (foreground)
- **`start_gradio_tmux.sh`** - Start Gradio app (background in tmux)
- **`deploy_gradio.sh`** - Full setup for Gradio app (if you want Gradio instead of FastAPI)

## 🔧 Usage Examples

### Chatterbox TTS API

#### First Time Setup
```bash
cd /workspace
git clone https://github.com/aydinmyilmaz/runpod-scripts.git
cd runpod-scripts/chatterbox
bash setup.sh          # One-time setup
bash start_api.sh      # Start the server
```

#### After Pod Restart
```bash
cd /workspace/runpod-scripts/chatterbox
bash start_api.sh      # Just start the server (setup already done)
```

#### After Code Updates
```bash
cd /workspace/runpod-scripts/chatterbox
bash restart_api.sh    # Pulls updates and restarts
```

### Coqui TTS (XTTS v2) API

#### First Time Setup
```bash
cd /workspace/runpod-scripts/xtts
bash setup_xtts.sh     # One-time setup
bash start_xtts.sh     # Start the server
```

#### After Pod Restart
```bash
cd /workspace/runpod-scripts/xtts
bash start_xtts.sh     # Just start the server (setup already done)
```

### Running Both APIs Simultaneously

Both APIs can run on the same pod:
```bash
# Terminal 1: Start Chatterbox TTS
cd /workspace/runpod-scripts/chatterbox
bash start_api.sh

# Terminal 2: Start Coqui XTTS
cd /workspace/runpod-scripts/xtts
bash start_xtts.sh
```

## 🌐 API Endpoints

### Chatterbox TTS API (Port 8004)

Available at `http://your-pod-id.runpod.net:8004`:

- **POST /tts** - Generate TTS audio
- **POST /upload_reference** - Upload reference audio files
- **GET /get_reference_files** - List uploaded reference files
- **GET /get_predefined_voices** - List predefined voices
- **GET /languages** - Get supported languages
- **GET /health** - Health check
- **GET /docs** - Interactive API documentation

### Coqui TTS (XTTS v2) API (Port 8005)

Available at `http://your-pod-id.runpod.net:8005`:

- **POST /tts** - Generate TTS audio
- **POST /upload_speaker** - Upload reference speaker audio
- **GET /speaker_files** - List speaker files
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

**Chatterbox TTS server won't start:**
- Make sure you ran `chatterbox/setup.sh` first
- Check logs: `tail -f /workspace/fastapi.log`
- Verify virtual environment exists: `ls /workspace/Chatterbox-Multilingual-TTS/venv`

**Coqui XTTS server won't start:**
- Make sure you ran `xtts/setup_xtts.sh` first
- Check logs: `tail -f /workspace/xtts.log`
- Verify virtual environment exists: `ls /workspace/Chatterbox-Multilingual-TTS/venv_xtts`

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
