import json
import os
from typing import List

import httpx
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

app = FastAPI(title="Uncensored AI Agent")

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")
DEFAULT_MODEL = os.getenv("DEFAULT_MODEL", "dolphin-mistral")


class Message(BaseModel):
    role: str
    content: str


class ChatRequest(BaseModel):
    model: str = DEFAULT_MODEL
    messages: List[Message]


async def stream_chat(model: str, messages: list):
    payload = {"model": model, "messages": messages, "stream": True}
    async with httpx.AsyncClient(timeout=None) as client:
        try:
            async with client.stream("POST", f"{OLLAMA_URL}/api/chat", json=payload) as resp:
                if resp.status_code != 200:
                    yield f"data: {json.dumps({'error': f'Ollama returned {resp.status_code}'})}\n\n"
                    return
                async for line in resp.aiter_lines():
                    if not line:
                        continue
                    try:
                        data = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if "message" in data:
                        content = data["message"].get("content", "")
                        if content:
                            yield f"data: {json.dumps({'content': content})}\n\n"
                    if data.get("done"):
                        yield "data: [DONE]\n\n"
        except httpx.ConnectError:
            yield f"data: {json.dumps({'error': 'Cannot connect to Ollama. Is it running? Run: ollama serve'})}\n\n"


@app.post("/api/chat")
async def chat(request: ChatRequest):
    return StreamingResponse(
        stream_chat(request.model, [m.dict() for m in request.messages]),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@app.get("/api/models")
async def list_models():
    async with httpx.AsyncClient(timeout=5) as client:
        try:
            resp = await client.get(f"{OLLAMA_URL}/api/tags")
            return resp.json()
        except Exception as e:
            return {"models": [], "error": str(e)}


app.mount("/", StaticFiles(directory="static", html=True), name="static")
