#!/usr/bin/env bash
set -e

MODEL="${DEFAULT_MODEL:-dolphin-mistral}"
PORT="${PORT:-8000}"

# Start Ollama in background if not running
if ! pgrep -x ollama &>/dev/null; then
  echo "Starting Ollama server..."
  ollama serve &>/tmp/ollama.log &
  for i in $(seq 1 20); do
    if curl -s http://localhost:11434/api/tags &>/dev/null; then
      break
    fi
    sleep 0.5
  done
  echo "✓ Ollama running"
else
  echo "✓ Ollama already running"
fi

echo "Starting Uncensored AI on http://localhost:${PORT}"
echo "Model: $MODEL"
echo "Press Ctrl+C to stop."
echo ""

DEFAULT_MODEL="$MODEL" uvicorn app:app --host 0.0.0.0 --port "$PORT" --reload
