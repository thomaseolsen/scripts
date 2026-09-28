#!/usr/bin/env bash

# Define operational ports
LLAMA_PORT=10000
WEBUI_PORT=8080

# Paths to executables
LLAMA_EXEC="/opt/homebrew/bin/llama"
WEBUI_EXEC="$(which open-webui)"

# Verify Open WebUI is installed
if [ -z "$WEBUI_EXEC" ]; then
    echo "❌ Error: open-webui binary not found in PATH."
    echo "Please ensure you have installed it via pipx and run 'pipx ensurepath'."
    exit 1
fi

echo "🚀 Launching local AI infrastructure..."

# 1. Start llama.cpp server in the background
echo "📦 Starting llama.cpp backend on port $LLAMA_PORT..."
$LLAMA_EXEC serve \
  -hf unsloth/Qwen3.5-9B-GGUF:Q5_K_M \
  -ngl 99 \
  -c 8192 \
  -t 6 \
  -fa on \
  --host 127.0.0.1 \
  --port $LLAMA_PORT \
  >> /tmp/llama-server.out.log 2>> /tmp/llama-server.err.log &

LLAMA_PID=$!

# Wait for llama.cpp to initialize and open the port
echo "⏱️  Waiting for backend API to initialize..."
while ! nc -z 127.0.0.1 $LLAMA_PORT; do   
  sleep 0.5
done
echo "✅ Backend API is reachable."

# 2. Configure environment variables for Open WebUI
export OPENAI_API_BASE_URL="http://127.0.0.1:$LLAMA_PORT/v1"
export OPENAI_API_KEY="llama.cpp-placeholder" # Bypasses internal validation check
export PORT=$WEBUI_PORT                        # Binds Open WebUI frontend to 8080

# Clean shutdown handling on Ctrl+C
cleanup() {
    echo -e "\n🛑 Shutting down servers..."
    kill $LLAMA_PID 2>/dev/null
    kill $WEBUI_PID 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# 3. Start Open WebUI frontend
echo "🖥️  Starting Open WebUI on port $WEBUI_PORT..."
echo "🔗 Access your UI at http://localhost:$WEBUI_PORT"
$WEBUI_EXEC serve >> /tmp/open-webui.out.log 2>> /tmp/open-webui.err.log &
WEBUI_PID=$!

# Keep script active in the foreground to monitor processes
wait $WEBUI_PID
