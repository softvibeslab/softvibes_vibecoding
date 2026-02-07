# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Vibecoding Ecosystem - Docker Image                                          ║
# ║  Imagen Docker con todo el ecosistema pre-instalado                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

FROM ubuntu:24.04

# Metadata
LABEL maintainer="Vibecoding"
LABEL description="Complete Vibecoding Ecosystem with Claude Code, OpenClaw, MoAI-ADK, GLM-4.7"
LABEL version="1.0.0"

# Evitar prompts interactivos durante instalación
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production

# Crear usuario no-root
RUN useradd -m -s /bin/bash vibecoder && \
    usermod -aG sudo vibecoder && \
    echo "vibecoder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vibecoder

# Directorio de trabajo
WORKDIR /home/vibecoder

# Instalar dependencias base
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    lsb-release \
    jq \
    ffmpeg \
    ripgrep \
    ufw \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Instalar PM2
RUN npm install -g pm2

# Instalar OpenClaw
RUN npm install -g openclaw@latest

# Crear directorios necesarios
RUN mkdir -p /home/vibecoder/.vibecoding && \
    mkdir -p /home/vibecoder/.claude && \
    mkdir -p /home/vibecoder/.openclaw && \
    mkdir -p /home/vibecoder/.openclaw/skills && \
    mkdir -p /home/vibecoder/.moai && \
    mkdir -p /var/log/vibecoding && \
    chown -R vibecoder:vibecoder /home/vibecoder/.vibecoding && \
    chown -R vibecoder:vibecoder /home/vibecoder/.claude && \
    chown -R vibecoder:vibecoder /home/vibecoder/.openclaw && \
    chown -R vibecoder:vibecoder /home/vibecoder/.moai && \
    chown -R vibecoder:vibecoder /var/log/vibecoding

# Instalar Awesome-OpenClaw-Skills
RUN git clone https://github.com/VoltAgent/awesome-openclaw-skills.git \
        /home/vibecoder/.openclaw/skills/awesome-openclaw-skills && \
    chown -R vibecoder:vibecoder /home/vibecoder/.openclaw/skills

# Instalar Pica SDK
RUN pip3 install zai-sdk openai

# Copiar scripts de configuración
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Configuración de Claude Code (placeholder)
RUN echo '{"autoUpdatesChannel":"latest"}' > /home/vibecoder/.claude/settings.json

# Configuración de OpenClaw (placeholder)
RUN echo '{"llm":{"provider":"z-ai","model":"glm-4.7"}}' > /home/vibecoder/.openclaw/config.json

# Exponer puertos
EXPOSE 3000 8000 8080

# Cambiar al usuario vibecoder
USER vibecoder

# Entry point
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD command -v claude && command -v openclaw || exit 1
