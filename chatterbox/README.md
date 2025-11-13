# Chatterbox TTS Scripts

Scripts for deploying and managing Chatterbox Multilingual TTS (FastAPI and Gradio).

## Scripts

### FastAPI Server (Port 8004)

- **`setup.sh`** - One-shot setup script. Run this ONCE when starting a new RunPod instance.
- **`start_api.sh`** - Start the FastAPI server (assumes setup is done)
- **`restart_api.sh`** - Restart the server after updates

### Gradio App (Port 7860)

- **`deploy_gradio.sh`** - Full setup for Gradio app
- **`start_gradio.sh`** - Start Gradio app (foreground)
- **`start_gradio_tmux.sh`** - Start Gradio app (background in tmux)

## Quick Start

### FastAPI Server

```bash
cd /workspace/runpod-scripts/chatterbox
bash setup.sh
bash start_api.sh
```

### Gradio App

```bash
cd /workspace/runpod-scripts/chatterbox
bash deploy_gradio.sh
bash start_gradio_tmux.sh
```

## API Endpoints

Server runs on port **8004**:
- `POST /tts` - Generate TTS audio
- `POST /upload_reference` - Upload reference audio files
- `GET /get_reference_files` - List uploaded reference files
- `GET /languages` - Get supported languages
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation

## More Information

- Main repository: https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS
- [Official Multilingual Documentation](https://chatterboxtts.com/docs/multilingual)
- [Hugging Face Space Demo](https://huggingface.co/spaces/ResembleAI/Chatterbox-Multilingual-TTS)

