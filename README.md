# Uncensored AI Agent

A ChatGPT-style web chat interface backed by **[dolphin-mistral](https://huggingface.co/cognitivecomputations/dolphin-2.1-mistral-7b)** — an uncensored fine-tune of Mistral 7B by Eric Hartford that removes all safety guidelines. The model is self-hosted locally via **[Ollama](https://ollama.com)**.

### Stack

| Layer | Technology |
|---|---|
| Inference | [Ollama](https://ollama.com) + `dolphin-mistral` (self-hosted) |
| Backend | Python / FastAPI (streaming SSE proxy) |
| Frontend | Vanilla HTML/CSS/JS (no framework) |

### Features

- Streaming token-by-token responses (like ChatGPT)
- Conversation history stored in `localStorage`
- Multiple conversations in a sidebar
- Model selector (auto-populated from Ollama — swap in any pulled model)
- Stop generation button
- Dark mode UI
- Markdown rendering (code blocks, bold, italic)

---

## Quick start

### Prerequisites

- macOS / Linux
- Python 3.9+
- [Ollama](https://ollama.com) (installed automatically by `setup.sh` if missing)

### 1. Clone and setup

```bash
git clone <this-repo>
cd Uncensored_AI_Agent

./setup.sh   # installs Ollama + Python deps + pulls dolphin-mistral (~4 GB)
```

### 2. Run

```bash
./start.sh
```

Open **http://localhost:8000** in your browser.

---

## Configuration

| Env var | Default | Description |
|---|---|---|
| `DEFAULT_MODEL` | `dolphin-mistral` | Ollama model to use |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama API base URL |
| `PORT` | `8000` | Web server port |

### Other uncensored models

```bash
ollama pull dolphin-llama3          # Dolphin on Llama 3 8B
ollama pull dolphin-mixtral         # Dolphin on Mixtral 8x7B
ollama pull wizard-vicuna-uncensored

# Start with a different model
DEFAULT_MODEL=dolphin-llama3 ./start.sh
```

---

## Deployment

To expose publicly, run on any VPS (needs ~8 GB RAM for 7B models):

```bash
# On the server
OLLAMA_URL=http://localhost:11434 PORT=80 ./start.sh
```
