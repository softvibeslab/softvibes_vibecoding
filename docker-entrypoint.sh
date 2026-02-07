#!/bin/bash
#
# Docker entrypoint para Vibecoding Ecosystem
#

# Cargar variables de entorno si existen
if [[ -f "/home/vibecoder/.vibecoding.env" ]]; then
    source /home/vibecoder/.vibecoding.env
fi

# Configurar Claude Code con las API keys si están disponibles
if [[ -n "${ZAI_API_KEY:-}" ]]; then
    cat > /home/vibecoder/.claude/settings.json << EOF
{
    "autoUpdatesChannel": "latest",
    "anthropicApiKey": "${ANTHROPIC_API_KEY:-$ZAI_API_KEY}",
    "customApiKeys": {
        "z-ai": "${ZAI_API_KEY}"
    }
}
EOF
fi

# Configurar OpenClaw
if [[ -n "${ZAI_API_KEY:-}" ]]; then
    cat > /home/vibecoder/.openclaw/config.json << EOF
{
    "llm": {
        "provider": "z-ai",
        "model": "${ZAI_MODEL:-glm-4.7}",
        "apiKey": "${ZAI_API_KEY}",
        "baseUrl": "${ZAI_BASE_URL:-https://api.z.ai/api/paas/v4/}"
    }
}
EOF
fi

# Configurar Telegram si hay token
if [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]]; then
    cat > /home/vibecoder/.openclaw/telegram.json << EOF
{
    "token": "${TELEGRAM_BOT_TOKEN}",
    "enabled": true
}
EOF
fi

# Ejecutar el comando pasado como argumento
exec "$@"
