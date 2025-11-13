# Coqui TTS (XTTS v2) API Scripts

Scripts for deploying and managing Coqui TTS (XTTS v2) FastAPI server.

## Scripts

- **`setup_xtts.sh`** - Setup Coqui TTS (XTTS v2) API - creates separate venv and installs dependencies
- **`start_xtts.sh`** - Start Coqui TTS API server on port 8005

## Quick Start

```bash
cd /workspace/runpod-scripts/xtts
bash setup_xtts.sh
bash start_xtts.sh
```

## API Endpoints

Server runs on port **8005**:
- `POST /tts` - Generate TTS audio
- `POST /upload_speaker` - Upload reference speaker audio
- `GET /speaker_files` - List speaker files
- `GET /languages` - Get supported languages
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation

## Notes

- **Separate virtual environment**: Uses `venv_xtts` to avoid dependency conflicts
- **Separate port**: Runs on port 8005 (Chatterbox TTS runs on 8004)
- **Can coexist**: Both APIs can run simultaneously on the same pod
- **Separate storage**: Reference audio stored in `reference_audio_xtts/`

## More Information

- Main repository: https://github.com/aydinmyilmaz/Chatterbox-Multilingual-TTS
- Coqui TTS Documentation: https://github.com/coqui-ai/TTS

