# Uncensored AI

A ChatGPT-style chat interface powered by **[dolphin-mistral](https://huggingface.co/cognitivecomputations/dolphin-2.1-mistral-7b)** — a community fine-tune of Mistral 7B by Eric Hartford with all safety filters removed. The model runs entirely self-hosted via [Ollama](https://ollama.com); no data leaves your infrastructure.

> **Note:** The hosted demo is currently offline. Run it locally with the instructions below — it takes about 5 minutes on a first install.

---

## Why dolphin-mistral

Standard models (GPT-4, Claude, Llama-instruct) refuse a wide range of requests due to RLHF safety training. dolphin-mistral is a fine-tune trained specifically to remove those restrictions — it follows instructions without content filters or refusals. This is distinct from prompt-engineering tricks on a standard model, which still refuse at the model level.

---

## Stack

| Layer | Technology |
|---|---|
| Model | [dolphin-mistral](https://ollama.com/library/dolphin-mistral) — uncensored Mistral 7B fine-tune |
| Inference | [Ollama](https://ollama.com) (self-hosted) |
| Backend | Python / [FastAPI](https://fastapi.tiangolo.com) — streaming SSE proxy |
| Frontend | Vanilla HTML / CSS / JS |
| Deployment | Docker Compose on a cloud VPS |

## Features

- Streaming token-by-token responses
- Persistent conversation history (stored in `localStorage`)
- Sidebar with multiple conversations
- Model selector — auto-populated from Ollama (swap in any locally pulled model)
- Stop generation mid-stream
- Dark mode UI
- Markdown rendering — code blocks, bold, italic

---

## Running locally

### System requirements

| | Minimum |
|---|---|
| OS | macOS, Linux, or Windows (WSL2) |
| RAM | 8 GB (16 GB recommended) |
| Disk | ~5 GB free for the model |
| Python | 3.9+ |

### Quick start (macOS / Linux)

```bash
git clone https://github.com/Charlarthebar/Uncensored_AI_Agent.git
cd Uncensored_AI_Agent
./setup.sh    # installs Ollama, pulls dolphin-mistral (~4 GB), installs Python deps
./start.sh    # starts the app at http://localhost:8000
```

Open **http://localhost:8000** in your browser. The first run takes a few minutes while `setup.sh` downloads the model.

`setup.sh` installs Ollama automatically if it isn't already present.

### Windows (WSL2)

1. [Install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) if you haven't already (`wsl --install` in PowerShell).
2. Open a WSL terminal and follow the macOS/Linux steps above.

### Manual setup (if the scripts don't work)

```bash
# 1. Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. Start the Ollama server (runs in the background)
ollama serve &

# 3. Pull the model (~4 GB download)
ollama pull dolphin-mistral

# 4. Install Python dependencies
pip3 install -r requirements.txt

# 5. Start the web app
DEFAULT_MODEL=dolphin-mistral uvicorn app:app --host 0.0.0.0 --port 8000
```

### Troubleshooting

**`ollama: command not found`** — Ollama wasn't added to your PATH. Close and reopen your terminal, or run `source ~/.bashrc` (Linux) / `source ~/.zshrc` (macOS).

**App starts but the model hangs / no response** — Ollama may still be loading. Check `ollama ps` to confirm the model is running. First inference after a cold start can take 10–30 seconds.

**Port 8000 already in use** — set a different port: `PORT=8080 ./start.sh`

**Out of memory errors** — Try a smaller model: `DEFAULT_MODEL=dolphin-phi ./start.sh` (Phi-2 based, ~1.6 GB).

---

## Deploying to a server

The included `docker-compose.yml` runs Ollama and the web app in containers:

```bash
# On a fresh Ubuntu server (8 GB RAM recommended)
curl -fsSL https://get.docker.com | sh
git clone https://github.com/Charlarthebar/Uncensored_AI_Agent.git
cd Uncensored_AI_Agent
docker compose up -d --build
docker compose exec ollama ollama pull dolphin-mistral
```

The app is then available on port 80.

---

## Configuration

| Variable | Default | Description |
|---|---|---|
| `DEFAULT_MODEL` | `dolphin-mistral` | Ollama model name to pre-select |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama API base URL |
| `PORT` | `8000` | Web server port |

### Other uncensored models

Any model pulled into Ollama appears automatically in the model selector:

```bash
ollama pull dolphin-llama3        # Dolphin on Llama 3 8B
ollama pull dolphin-mixtral       # Dolphin on Mixtral 8x7B
ollama pull wizard-vicuna-uncensored
```
