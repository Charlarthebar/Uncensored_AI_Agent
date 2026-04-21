#!/usr/bin/env bash
set -e

echo "=== Uncensored AI Agent — Setup ==="

# 1. Install Ollama if missing
if ! command -v ollama &>/dev/null; then
  echo "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "✓ Ollama already installed ($(ollama --version 2>&1 | head -1))"
fi

# 2. Install Python deps
echo "Installing Python dependencies..."
pip3 install -r requirements.txt -q --upgrade
echo "✓ Python dependencies installed"

# 3. Start Ollama server if not already running
OLLAMA_STARTED=false
if ! curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &>/tmp/ollama_setup.log &
  OLLAMA_PID=$!
  OLLAMA_STARTED=true
  for i in $(seq 1 30); do
    if curl -s http://localhost:11434/api/tags &>/dev/null; then
      echo "✓ Ollama server ready"
      break
    fi
    sleep 0.5
  done
else
  echo "✓ Ollama server already running"
fi

# 4. Pull uncensored model
MODEL="${DEFAULT_MODEL:-dolphin-mistral}"
echo "Pulling model: $MODEL  (this may take a few minutes on first run)"
ollama pull "$MODEL"

if [ "$OLLAMA_STARTED" = true ]; then
  kill "$OLLAMA_PID" 2>/dev/null || true
fi

echo ""
echo "✓ Setup complete! Run ./start.sh to launch the app."
