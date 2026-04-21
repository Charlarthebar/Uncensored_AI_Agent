# Uncensored_AI_Agent
The task: Build a ChatGPT-style interface with an "uncensored" AI agent — one that bypasses standard content filters and refusals.

A few guidelines:

  • Complete the project independently using Claude Code or your preferred AI coding assistant
  • You're free to use any open-source projects for the WebUI and inference engine.
  • To be clear: this isn't about tweaking a system prompt on a standard model — those will still refuse most content. You'll need to find and self-host a truly uncensored/unfiltered model (there are plenty of community fine-tunes out there).
  • Host the WebUI wherever you like. We'll reimburse hosting and llm API costs up to $50.

---

## What was built

A ChatGPT-style web chat interface backed by **[dolphin-mistral](https://huggingface.co/cognitivecomputations/dolphin-2.1-mistral-7b)** — an uncensored fine-tune of Mistral 7B by Eric Hartford that removes all safety guidelines. The model is self-hosted locally via **[Ollama](https://ollama.com)**.

### Stack

| Layer | Technology |
|---|---|
| Inference | [Ollama](https://ollama.com) + `dolphin-mistral` |
| Backend | Python / FastAPI (streaming SSE proxy) |
| Frontend | Vanilla HTML/CSS/JS (no framework) |

### Features

- Streaming token-by-token responses (like ChatGPT)
- Conversation history stored in `localStorage`
- Multiple conversations in a sidebar
- Model selector (auto-populated from Ollama)
- Stop generation button
- Dark mode UI
- Markdown rendering (code blocks, bold, italic)

---

## Quick start

### Prerequisites

- macOS / Linux
- Python 3.9+
- [Ollama](https://ollama.com) (installed automatically by setup.sh if missing)

### 1. Clone and setup

```bash
git clone <this-repo>
cd Uncensored_AI_Agent

./setup.sh   # installs deps + pulls dolphin-mistral (~4 GB)
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

### Use a different uncensored model

```bash
# Pull an alternative
ollama pull dolphin-llama3        # Llama 3 8B uncensored
ollama pull llama2-uncensored     # Llama 2 uncensored
ollama pull wizard-vicuna-uncensored

# Start with that model
DEFAULT_MODEL=dolphin-llama3 ./start.sh
```

---

## Deployment (optional)

To expose the app publicly, run it on any VPS (e.g. DigitalOcean, Hetzner) with enough RAM for the model (~8 GB for 7B models):

```bash
# On the server — start Ollama, pull the model, then:
OLLAMA_URL=http://localhost:11434 PORT=80 ./start.sh
```

Or put it behind nginx/caddy for HTTPS.
