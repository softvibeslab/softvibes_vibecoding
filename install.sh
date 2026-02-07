#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Vibecoding Ecosystem Installer                                             ║
# ║  Instalación automática del ecosistema completo de Vibecoding               ║
# ║                                                                            ║
# ║  Componentes:                                                              ║
# ║  • Claude Code (Anthropic)                                                 ║
# ║  • OpenClaw (Personal AI Assistant)                                        ║
# ║  • MoAI-ADK (Agentic Development Kit)                                      ║
# ║  • Z.AI GLM-4.7 Integration                                                ║
# ║  • Pica SDK (API Integration Layer)                                        ║
# ║  • Awesome-OpenClaw-Skills                                                ║
# ║                                                                            ║
# ║  Requisitos: Ubuntu 20.04+ / Debian 10+                                   ║
# ║  Uso: sudo ./install.sh                                                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#

set -e  # Exit on error
set -u  # Exit on undefined variable

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURACIÓN
# ═══════════════════════════════════════════════════════════════════════════════

readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/vibecoding_install_$(date +%Y%m%d_%H%M%S).log"
readonly ENV_FILE="${SCRIPT_DIR}/.vibecoding.env"

# Colores para output
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_RESET='\033[0m'

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCIONES DE UTILIDAD
# ═══════════════════════════════════════════════════════════════════════════════

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "$LOG_FILE"
}

log_info() { log "INFO" "$@"; echo -e "${COLOR_CYAN}$*${COLOR_RESET}"; }
log_success() { log "SUCCESS" "$@"; echo -e "${COLOR_GREEN}$*${COLOR_RESET}"; }
log_warning() { log "WARNING" "$@"; echo -e "${COLOR_YELLOW}$*${COLOR_RESET}"; }
log_error() { log "ERROR" "$@"; echo -e "${COLOR_RED}$*${COLOR_RESET}" >&2; }
log_step() { log "STEP" "$@"; echo -e "${COLOR_BLUE}▶ $*${COLOR_RESET}"; }

show_banner() {
    cat << "EOF"

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██   ██ ██    ██ ██████  ███████ ██████  ██    ██ ███    ██  ██████       ║
║    ██ ██  ██    ██ ██   ██ ██      ██   ██  ██  ██  ████   ██ ██             ║
║     ███   ██    ██ ██████  █████   ██████    ████   ██ ██  ██ ██   ███       ║
║    ██ ██  ██    ██ ██      ██      ██   ██    ██    ██  ██ ██ ██    ██       ║
║   ██   ██  ██████  ██      ███████ ██   ██    ██    ██   ████  ██████        ║
║                                                                              ║
║                   Ecosystem Installer v1.0.0                                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script debe ejecutarse con privilegios de root (sudo)."
        log_info "Ejemplo: sudo ./install.sh"
        exit 1
    fi
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    else
        log_error "No se pudo detectar el sistema operativo."
        exit 1
    fi

    log_info "Sistema detectado: $DISTRO $VERSION"

    case "$DISTRO" in
        ubuntu|debian)
            log_success "Sistema compatible detectado."
            ;;
        *)
            log_warning "Sistema no testeado: $DISTRO. Continuando de todos modos..."
            ;;
    esac
}

check_requirements() {
    log_step "Verificando requisitos mínimos..."

    # Verificar RAM (mínimo 4GB recomendado)
    local total_mem=$(free -m | awk '/^Mem:/{print $2}')
    if [[ $total_mem -lt 2048 ]]; then
        log_warning "Memoria RAM baja: ${total_mem}MB. Se recomiendan al menos 4GB."
    else
        log_success "Memoria RAM: ${total_mem}MB OK"
    fi

    # Verificar espacio en disco
    local available_space=$(df -m / | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 5120 ]]; then
        log_error "Espacio en disco insuficiente. Se requieren al menos 5GB libres."
        exit 1
    fi
    log_success "Espacio en disco: ${available_space}MB OK"

    # Verificar conexión a internet
    if ! ping -c 1 -W 3 google.com &> /dev/null; then
        log_warning "No se detectó conexión a internet. Algunos componentes pueden fallar."
    else
        log_success "Conexión a internet OK"
    fi
}

prompt_credentials() {
    log_step "Configuración de credenciales y API Keys"

    echo ""
    echo "Se necesitan las siguientes API Keys para la configuración:"
    echo ""
    echo "  1. Z.AI API Key (para GLM-4.7) - OBTENER EN: https://docs.z.ai"
    echo "  2. Pica Secret Key - OBTENER EN: https://docs.picaos.com"
    echo "  3. (Opcional) Telegram Bot Token - PARA: OpenClaw"
    echo ""

    # Leer API Keys
    read -rp "→ Ingresa tu Z.AI API Key: " ZAI_API_KEY
    while [[ -z "$ZAI_API_KEY" ]]; do
        log_error "La API Key de Z.AI es obligatoria."
        read -rp "→ Ingresa tu Z.AI API Key: " ZAI_API_KEY
    done

    read -rp "→ Ingresa tu Pica Secret Key: " PICA_SECRET_KEY
    while [[ -z "$PICA_SECRET_KEY" ]]; do
        log_error "La Secret Key de Pica es obligatoria."
        read -rp "→ Ingresa tu Pica Secret Key: " PICA_SECRET_KEY
    done

    # Telegram es opcional
    echo ""
    read -rp "→ Ingresa tu Telegram Bot Token (opcional, presiona Enter para omitir): " TELEGRAM_BOT_TOKEN

    # Usuario no-root
    echo ""
    read -rp "→ Nombre de usuario no-root para ejecutar los servicios (default: vibecoder): " NON_ROOT_USER
    NON_ROOT_USER=${NON_ROOT_USER:-vibecoder}

    # Resumen
    echo ""
    log_info "Resumen de configuración:"
    echo "  Z.AI API Key: ${ZAI_API_KEY:0:10}..."
    echo "  Pica Secret Key: ${PICA_SECRET_KEY:0:10}..."
    echo "  Telegram Bot: ${TELEGRAM_BOT_TOKEN:-"No configurado"}"
    echo "  Usuario: $NON_ROOT_USER"
    echo ""

    read -rp "¿Continuar con esta configuración? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        log_info "Instalación cancelada por el usuario."
        exit 0
    fi
}

save_env_file() {
    cat > "$ENV_FILE" << ENVFILE
# ═══════════════════════════════════════════════════════════════════════════════
# Vibecoding Ecosystem - Environment Variables
# Generado automáticamente: $(date)
# ═══════════════════════════════════════════════════════════════════════════════

# Z.AI / GLM-4.7 Configuration
export ZAI_API_KEY="${ZAI_API_KEY}"
export ZAI_BASE_URL="https://api.z.ai/api/paas/v4/"
export ZAI_MODEL="glm-4.7"

# Pica Configuration
export PICA_SECRET_KEY="${PICA_SECRET_KEY}"

# Telegram Configuration (for OpenClaw)
${TELEGRAM_BOT_TOKEN:+export TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"}

# User Configuration
export VIBE_USER="${NON_ROOT_USER}"
export VIBE_HOME="/home/${NON_ROOT_USER}"

# Paths
export VIBE_INSTALL_DIR="\${VIBE_HOME}/.vibecoding"
export VIBE_LOG_DIR="/var/log/vibecoding"

# ═══════════════════════════════════════════════════════════════════════════════
ENVFILE

    chmod 600 "$ENV_FILE"
    log_success "Archivo de entorno guardado en: $ENV_FILE"
}

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCIONES DE INSTALACIÓN
# ═══════════════════════════════════════════════════════════════════════════════

install_base_dependencies() {
    log_step "Instalando dependencias base..."

    apt update >> "$LOG_FILE" 2>&1
    apt upgrade -y >> "$LOG_FILE" 2>&1

    local packages=(
        curl
        wget
        git
        build-essential
        python3
        python3-pip
        python3-venv
        nodejs
        npm
        ufw
        jq
        ffmpeg
        ripgrep
    )

    apt install -y "${packages[@]}" >> "$LOG_FILE" 2>&1

    # Instalar Node.js LTS si la versión es muy antigua
    local node_version=$(nodejs -v 2>/dev/null | cut -d'v' -f2 | cut -d'.' -f1)
    if [[ -n "$node_version" && "$node_version" -lt 18 ]]; then
        log_warning "Node.js versión antigua detectada. Instalando LTS..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >> "$LOG_FILE" 2>&1
        apt install -y nodejs >> "$LOG_FILE" 2>&1
    fi

    log_success "Dependencias base instaladas."
}

create_user() {
    log_step "Configurando usuario del sistema..."

    if id "$NON_ROOT_USER" &>/dev/null; then
        log_info "El usuario $NON_ROOT_USER ya existe."
    else
        log_info "Creando usuario $NON_ROOT_USER..."
        useradd -m -s /bin/bash "$NON_ROOT_USER" >> "$LOG_FILE" 2>&1
        usermod -aG sudo "$NON_ROOT_USER" >> "$LOG_FILE" 2>&1

        # Configurar sudo sin contraseña para tareas específicas
        echo "$NON_ROOT_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/pm2, /usr/bin/claude, /usr/bin/openclaw" > "/etc/sudoers.d/vibecoding-${NON_ROOT_USER}"
        chmod 440 "/etc/sudoers.d/vibecoding-${NON_ROOT_USER}"

        log_success "Usuario $NON_ROOT_USER creado."
    fi

    # Crear directorios necesarios
    local user_home="/home/$NON_ROOT_USER"
    mkdir -p "$user_home/.vibecoding"
    mkdir -p "$user_home/.claude"
    mkdir -p "$user_home/.openclaw"
    mkdir -p "$user_home/.config"
    mkdir -p "/var/log/vibecoding"

    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.vibecoding"
    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.claude"
    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.openclaw"
    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "/var/log/vibecoding"
}

install_claude_code() {
    log_step "Instalando Claude Code..."

    local user_home="/home/$NON_ROOT_USER"

    # Instalar como el usuario no-root
    su - "$NON_ROOT_USER" -c "curl -fsSL https://claude.ai/install.sh | bash" >> "$LOG_FILE" 2>&1

    # Configurar Claude Code
    cat > "$user_home/.claude/settings.json" << CLAUDE_CONFIG
{
    "autoUpdatesChannel": "latest",
    "editor": {
        "formatOnSave": true
    },
    "anthropicApiKey": "${ZAI_API_KEY}",
    "customApiKeys": {
        "z-ai": "${ZAI_API_KEY}"
    }
}
CLAUDE_CONFIG

    # Configurar soporte para múltiples LLMs
    cat > "$user_home/.claude/models.json" << MODELS_CONFIG
{
    "providers": {
        "z-ai": {
            "baseUrl": "https://api.z.ai/api/paas/v4/",
            "models": ["glm-4.7", "glm-4.7-flash", "glm-4.7-flashx"]
        }
    },
    "defaultModel": "glm-4.7"
}
MODELS_CONFIG

    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.claude"

    # Verificar instalación
    if su - "$NON_ROOT_USER" -c "command -v claude" >> "$LOG_FILE" 2>&1; then
        local claude_version=$(su - "$NON_ROOT_USER" -c "claude --version 2>/dev/null || echo 'installed'")
        log_success "Claude Code instalado: $claude_version"
    else
        log_warning "Claude Code se instaló pero no está en PATH. Puede necesitar recargar la shell."
    fi
}

install_openclaw() {
    log_step "Instalando OpenClaw..."

    local user_home="/home/$NON_ROOT_USER"

    # Instalar OpenClaw globalmente via npm
    su - "$NON_ROOT_USER" -c "npm install -g openclaw@latest" >> "$LOG_FILE" 2>&1

    # Configurar OpenClaw
    mkdir -p "$user_home/.openclaw/skills"

    cat > "$user_home/.openclaw/config.json" << OPENCLAW_CONFIG
{
    "llm": {
        "provider": "z-ai",
        "model": "glm-4.7",
        "apiKey": "${ZAI_API_KEY}",
        "baseUrl": "https://api.z.ai/api/paas/v4/"
    },
    "channels": {
        "enabled": ["terminal"]
    }
}
OPENCLAW_CONFIG

    # Configurar Telegram si se proporcionó token
    if [[ -n "$TELEGRAM_BOT_TOKEN" ]]; then
        cat > "$user_home/.openclaw/telegram.json" << TELEGRAM_CONFIG
{
    "token": "${TELEGRAM_BOT_TOKEN}",
    "enabled": true
}
TELEGRAM_CONFIG
    fi

    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.openclaw"

    # Verificar instalación
    if su - "$NON_ROOT_USER" -c "command -v openclaw" >> "$LOG_FILE" 2>&1; then
        log_success "OpenClaw instalado correctamente."
    else
        log_error "OpenClaw no se pudo instalar correctamente."
        return 1
    fi
}

install_moai_adk() {
    log_step "Instalando MoAI-ADK..."

    local user_home="/home/$NON_ROOT_USER"

    # MoAI-ADK se instala por proyecto, pero instalamos la CLI globalmente
    su - "$NON_ROOT_USER" -c "npm install -g @modu-ai/moai-adk" >> "$LOG_FILE" 2>&1 || {
        log_warning "MoAI-ADK no está disponible via npm. Clonando desde GitHub..."
        su - "$NON_ROOT_USER" -c "git clone https://github.com/modu-ai/moai-adk.git $user_home/.vibecoding/moai-adk" >> "$LOG_FILE" 2>&1
        su - "$NON_ROOT_USER" -c "cd $user_home/.vibecoding/moai-adk && npm install" >> "$LOG_FILE" 2>&1
        su - "$NON_ROOT_USER" -c "npm link -g $user_home/.vibecoding/moai-adk" >> "$LOG_FILE" 2>&1 || true
    }

    # Configurar MoAI-ADK
    mkdir -p "$user_home/.moai"
    cat > "$user_home/.moai/config.json" << MOAI_CONFIG
{
    "llm": {
        "provider": "z-ai",
        "model": "glm-4.7",
        "apiKey": "${ZAI_API_KEY}",
        "baseUrl": "https://api.z.ai/api/paas/v4/"
    },
    "agents": {
        "default": "alfred"
    }
}
MOAI_CONFIG

    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.moai"

    log_success "MoAI-ADK instalado."
}

install_pica_sdk() {
    log_step "Instalando Pica SDK..."

    local user_home="/home/$NON_ROOT_USER"

    # Instalar Pica SDK para Python
    su - "$NON_ROOT_USER" -c "pip3 install --user pica-ai" >> "$LOG_FILE" 2>&1 || {
        log_warning "pica-ai no encontrado en PyPI. Instalando desde fuente..."
        su - "$NON_ROOT_USER" -c "pip3 install --user picahq" >> "$LOG_FILE" 2>&1 || {
            log_warning "Instalando OpenAI SDK para compatibilidad con Pica..."
            su - "$NON_ROOT_USER" -c "pip3 install --user openai" >> "$LOG_FILE" 2>&1
        }
    }

    # Instalar Pica SDK para Node.js
    su - "$NON_ROOT_USER" -c "npm install -g @picahq/ai" >> "$LOG_FILE" 2>&1 || {
        log_warning "Pica Node SDK no disponible. Continuando sin él..."
    }

    # Crear script de ejemplo
    cat > "$user_home/.vibecoding/pica_example.py" << PICA_EXAMPLE
#!/usr/bin/env python3
"""
Pica Integration Example for Vibecoding
"""

import os
from openai import OpenAI

# Pica usa OpenAI-compatible API
PICA_API_KEY = os.environ.get("PICA_SECRET_KEY", "${PICA_SECRET_KEY}")

client = OpenAI(
    api_key=PICA_API_KEY,
    base_url="https://api.picaos.com/v1"
)

def test_pica_connection():
    """Test Pica API connection"""
    try:
        # List available connectors/integrations
        response = client.connectors.list()
        print("Pica connection successful!")
        return True
    except Exception as e:
        print(f"Pica connection error: {e}")
        return False

if __name__ == "__main__":
    test_pica_connection()
PICA_EXAMPLE

    chmod +x "$user_home/.vibecoding/pica_example.py"
    chown "$NON_ROOT_USER:$NON_ROOT_USER" "$user_home/.vibecoding/pica_example.py"

    log_success "Pica SDK instalado."
}

install_openclaw_skills() {
    log_step "Instalando Awesome-OpenClaw-Skills..."

    local user_home="/home/$NON_ROOT_USER"
    local skills_dir="$user_home/.openclaw/skills"

    # Clonar el repositorio de skills
    if [[ ! -d "$skills_dir/awesome-openclaw-skills" ]]; then
        su - "$NON_ROOT_USER" -c "git clone https://github.com/VoltAgent/awesome-openclaw-skills.git $skills_dir/awesome-openclaw-skills" >> "$LOG_FILE" 2>&1
    else
        log_info "El repositorio de skills ya existe. Actualizando..."
        su - "$NON_ROOT_USER" -c "cd $skills_dir/awesome-openclaw-skills && git pull" >> "$LOG_FILE" 2>&1
    fi

    # Instalar skills clave
    local key_skills=("claude-code" "git-github" "devops" "web-dev" "browser")

    for skill in "${key_skills[@]}"; do
        log_info "Instalando skill: $skill"
        su - "$NON_ROOT_USER" -c "npx clawhub@latest install $skill" >> "$LOG_FILE" 2>&1 || {
            log_warning "No se pudo instalar el skill $skill via ClawHub."
        }
    done

    # Copiar skills manualmente si ClawHub falló
    if [[ -d "$skills_dir/awesome-openclaw-skills/skills" ]]; then
        cp -r "$skills_dir/awesome-openclaw-skills/skills/"* "$skills_dir/" 2>/dev/null || true
    fi

    chown -R "$NON_ROOT_USER:$NON_ROOT_USER" "$skills_dir"

    log_success "Skills de OpenClaw instaladas."
}

install_pm2() {
    log_step "Instalando PM2 para gestión de procesos..."

    su - "$NON_ROOT_USER" -c "npm install -g pm2" >> "$LOG_FILE" 2>&1
    su - "$NON_ROOT_USER" -c "pm2 startup systemd -u $NON_ROOT_USER --hp /home/$NON_ROOT_USER" >> "$LOG_FILE" 2>&1 || {
        log_warning "PM2 startup script ya configurado o falló."
    }

    log_success "PM2 instalado."
}

configure_firewall() {
    log_step "Configurando firewall..."

    # Permitir SSH
    ufw allow OpenSSH >> "$LOG_FILE" 2>&1

    # Permitir puertos comunes para desarrollo
    ufw allow 3000/tcp >> "$LOG_FILE" 2>&1  # React/dev server
    ufw allow 8000/tcp >> "$LOG_FILE" 2>&1  # Python backend
    ufw allow 8080/tcp >> "$LOG_FILE" 2>&1  # Alternative

    # Habilitar firewall
    echo "y" | ufw enable >> "$LOG_FILE" 2>&1 || {
        log_warning "Firewall ya está habilitado."
    }

    log_success "Firewall configurado."
}

create_aliases() {
    log_step "Creando aliases y atajos..."

    local user_home="/home/$NON_ROOT_USER"
    local bashrc="$user_home/.bashrc"

    # Agregar aliases si no existen
    if ! grep -q "# Vibecoding Aliases" "$bashrc" 2>/dev/null; then
        cat >> "$bashrc" << 'ALIASES'

# ═══════════════════════════════════════════════════════════════════════════════
# Vibecoding Aliases
# ═══════════════════════════════════════════════════════════════════════════════

alias vibecode='claude'
alias vclaw='openclaw'
alias vmoai='moai'
alias vlogs='tail -f /var/log/vibecoding/*.log'

# Quick start functions
vibe-start() {
    cd ~/.vibecoding
    openclaw start
}

vibe-stop() {
    pm2 stop all
}

vibe-status() {
    echo "=== Vibecoding Status ==="
    echo "Claude Code: $(command -v claude &>/dev/null && echo 'Installed' || echo 'Not found')"
    echo "OpenClaw: $(command -v openclaw &>/dev/null && echo 'Installed' || echo 'Not found')"
    pm2 list
}

# MoAI quick commands
moai-init() {
    cd "$1" && claude /moai:project
}
ALIASES

        log_success "Aliases creados en ~/.bashrc"
    else
        log_info "Los aliases ya existen en ~/.bashrc"
    fi
}

create_systemd_services() {
    log_step "Creando servicios systemd..."

    # Servicio para OpenClaw
    cat > "/etc/systemd/system/openclaw.service" << SERVICE
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=${NON_ROOT_USER}
WorkingDirectory=/home/${NON_ROOT_USER}
Environment="PATH=/home/${NON_ROOT_USER}/.local/bin:/usr/local/bin:/usr/bin:/bin"
EnvironmentFile=${ENV_FILE}
ExecStart=/usr/bin/openclaw start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

    systemctl daemon-reload >> "$LOG_FILE" 2>&1
    systemctl enable openclaw.service >> "$LOG_FILE" 2>&1 || {
        log_warning "No se pudo habilitar el servicio openclaw.service"
    }

    log_success "Servicios systemd creados."
}

run_verification() {
    log_step "Verificando instalación..."

    local user_home="/home/$NON_ROOT_USER"

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════"
    echo "VERIFICACIÓN DE COMPONENTES"
    echo "═══════════════════════════════════════════════════════════════════════"
    echo ""

    # Verificar Node.js
    if command -v node &>/dev/null; then
        echo -e "  ✓ Node.js: $(node -v)"
    else
        echo -e "  ✗ Node.js: No instalado"
    fi

    # Verificar Python
    if command -v python3 &>/dev/null; then
        echo -e "  ✓ Python3: $(python3 --version)"
    else
        echo -e "  ✗ Python3: No instalado"
    fi

    # Verificar Claude Code
    if su - "$NON_ROOT_USER" -c "command -v claude" &>/dev/null; then
        echo -e "  ✓ Claude Code: Instalado"
    else
        echo -e "  ✗ Claude Code: No encontrado (puede requerir recargar shell)"
    fi

    # Verificar OpenClaw
    if command -v openclaw &>/dev/null; then
        echo -e "  ✓ OpenClaw: $(openclaw --version 2>/dev/null || echo 'Instalado')"
    else
        echo -e "  ✗ OpenClaw: No encontrado"
    fi

    # Verificar PM2
    if command -v pm2 &>/dev/null; then
        echo -e "  ✓ PM2: $(pm2 --version 2>/dev/null)"
    else
        echo -e "  ✗ PM2: No encontrado"
    fi

    # Verificar archivos de configuración
    echo ""
    echo "Archivos de configuración:"
    [[ -f "$ENV_FILE" ]] && echo -e "  ✓ $ENV_FILE" || echo -e "  ✗ $ENV_FILE"
    [[ -f "$user_home/.claude/settings.json" ]] && echo -e "  ✓ ~/.claude/settings.json" || echo -e "  ✗ ~/.claude/settings.json"
    [[ -f "$user_home/.openclaw/config.json" ]] && echo -e "  ✓ ~/.openclaw/config.json" || echo -e "  ✗ ~/.openclaw/config.json"
    [[ -d "$user_home/.openclaw/skills" ]] && echo -e "  ✓ ~/.openclaw/skills/" || echo -e "  ✗ ~/.openclaw/skills/"

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════"
}

print_final_message() {
    cat << EOF

${COLOR_GREEN}╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                    ¡INSTALACIÓN COMPLETADA!                                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝${COLOR_RESET}

${COLOR_CYAN}Próximos pasos:${COLOR_RESET}

  1.${COLOR_GREEN} Recargar la shell${COLOR_RESET} (o salir y volver a entrar):
     $ source ~/.bashrc
     $ su - ${NON_ROOT_USER}

  2.${COLOR_GREEN} Iniciar OpenClaw${COLOR_RESET}:
     $ openclaw start
     # o usar systemd:
     $ sudo systemctl start openclaw

  3.${COLOR_GREEN} Probar Claude Code${COLOR_RESET}:
     $ cd tu-proyecto
     $ claude

  4.${COLOR_GREEN} Iniciar un proyecto con MoAI${COLOR_RESET}:
     $ mkdir mi-proyecto && cd mi-proyecto
     $ claude /moai:project

  5.${COLOR_GREEN} Verificar estado${COLOR_RESET}:
     $ vibe-status

${COLOR_CYAN}Comandos útiles:${COLOR_RESET}
  - vibecode      → Ejecuta Claude Code
  - vclaw         → Ejecuta OpenClaw
  - vmoai         → Ejecuta MoAI-ADK
  - vlogs         → Ver logs en tiempo real
  - vibe-status   → Estado de los servicios

${COLOR_CYAN}Archivos de configuración:${COLOR_RESET}
  - $ENV_FILE
  - ~/.claude/settings.json
  - ~/.openclaw/config.json
  - ~/.moai/config.json

${COLOR_CYAN}Documentación:${COLOR_RESET}
  - Claude Code: https://code.claude.com/docs
  - OpenClaw: https://openclaw.ai
  - MoAI-ADK: https://github.com/modu-ai/moai-adk
  - Z.AI GLM-4.7: https://docs.z.ai/guides/llm/glm-4.7
  - Pica: https://docs.picaos.com

${COLOR_YELLOW}Nota:${COLOR_RESET} Si algún comando no funciona, recarga tu shell con:
  $ exec bash

${COLOR_BLUE}Log de instalación guardado en:${COLOR_RESET} $LOG_FILE

EOF
}

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCIÓN PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    show_banner
    check_root
    detect_os
    check_requirements
    prompt_credentials
    save_env_file

    # Instalación
    install_base_dependencies
    create_user
    install_claude_code
    install_openclaw
    install_moai_adk
    install_pica_sdk
    install_openclaw_skills
    install_pm2
    configure_firewall
    create_aliases
    create_systemd_services

    # Verificación
    run_verification
    print_final_message
}

# Ejecutar función principal
main "$@"
