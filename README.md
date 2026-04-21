# Uncensored AI

A ChatGPT-style chat interface powered by **[dolphin-mistral](https://huggingface.co/cognitivecomputations/dolphin-2.1-mistral-7b)** — a community fine-tune of Mistral 7B by Eric Hartford with all safety filters removed. The model runs entirely self-hosted via [Ollama](https://ollama.com); no data leaves your infrastructure.

**Live demo:** http://uncensored-ai-agent.duckdns.org

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

**Prerequisites:** Python 3.9+, macOS or Linux

```bash
git clone https://github.com/Charlarthebar/Uncensored_AI_Agent.git
cd Uncensored_AI_Agent
./setup.sh    # installs Ollama, pulls dolphin-mistral (~4 GB), installs Python deps
./start.sh    # starts the app at http://localhost:8000
```

`setup.sh` installs Ollama automatically if it isn't already present.

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
