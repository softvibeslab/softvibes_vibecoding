#  Manual Técnico - Vibecoding Ecosystem

##  Contenido

1. [Arquitectura del Sistema](#1-arquitectura-del-sistema)
2. [Componentes](#2-componentes)
3. [Flujo de Datos](#3-flujo-de-datos)
4. [Configuración Avanzada](#4-configuración-avanzada)
5. [Integraciones](#5-integraciones)
6. [Seguridad](#6-seguridad)
7. [Rendimiento](#7-rendimiento)
8. [Mantenimiento](#8-mantenimiento)
9. [Troubleshooting Avanzado](#9-troubleshooting-avanzado)

---

## 1. Arquitectura del Sistema

### 1.1 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              VIBECODING ECOSYSTEM                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐               │
│  │   USUARIO    │────▶│  OpenClaw    │────▶│  Claude Code │               │
│  │  (Terminal/  │     │   (Hub IA)   │     │   (Generador) │               │
│  │   Chat App)  │     └──────┬───────┘     └──────┬───────┘               │
│  └──────────────┘            │                     │                        │
│                              ▼                     ▼                        │
│                       ┌──────────────┐     ┌──────────────┐               │
│                       │  MoAI-ADK    │◀────│  GLM-4.7     │               │
│                       │  (Orquestador)│     │  (LLM Engine)│               │
│                       └──────┬───────┘     └──────────────┘               │
│                              │                                              │
│                              ▼                                              │
│                       ┌──────────────┐     ┌──────────────┐               │
│                       │    Pica      │────▶│  SaaS APIs   │               │
│                       │ (Integración)│     │ (26,000+ apps)│              │
│                       └──────────────┘     └──────────────┘               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Stack Tecnológico

| Capa | Tecnología | Propósito |
|------|------------|-----------|
| **Interfaz** | Terminal, Telegram, WhatsApp | Canales de usuario |
| **Orquestación** | OpenClaw, MoAI-ADK | Coordinación de agentes |
| **Generación** | Claude Code, GLM-4.7 | Creación de código |
| **Integración** | Pica SDK | Conexión con APIs externas |
| **Gestión** | PM2, systemd | Manejo de procesos |
| **Contenedorización** | Docker, Docker Compose | Aislamiento y portabilidad |

### 1.3 Directorios del Sistema

```
/home/vibecoder/
├── .vibecoding/              # Directorio principal del ecosistema
│   ├── projects/             # Proyectos del usuario
│   └── pica_example.py       # Ejemplo de integración
│
├── .claude/                  # Configuración de Claude Code
│   ├── settings.json         # Configuración principal
│   ├── models.json           # Modelos LLM
│   └── history/              # Historial de conversaciones
│
├── .openclaw/                # Configuración de OpenClaw
│   ├── config.json           # Config principal
│   ├── telegram.json         # Config de Telegram (si aplica)
│   └── skills/               # Skills instalados
│       ├── awesome-openclaw-skills/
│       ├── claude-code/
│       ├── git-github/
│       └── ...
│
├── .moai/                    # Configuración de MoAI-ADK
│   ├── config.json           # Config de agentes
│   └── agents/               # Definiciones de agentes
│
└── .pm2/                     # Datos de PM2
    ├── logs/                 # Logs de procesos
    └── dump.pm2              # Config de procesos guardados
```

---

## 2. Componentes

### 2.1 Claude Code

**Descripción:** CLI de Anthropic para generación de código asistida por IA.

**Archivos clave:**
- `~/.claude/settings.json` - Configuración principal
- `~/.claude/models.json` - Modelos configurados
- `~/.local/bin/claude` - Binario ejecutable

**Configuración avanzada:**

```json
{
    "autoUpdatesChannel": "latest",
    "editor": {
        "formatOnSave": true,
        "tabSize": 4
    },
    "anthropicApiKey": "sk-ant-...",
    "customApiKeys": {
        "z-ai": "zai-..."
    },
    "mcpServers": {
        "github": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-github"]
        }
    }
}
```

### 2.2 OpenClaw

**Descripción:** Asistente IA personal que actúa como hub central.

**Arquitectura:**

```
OpenClaw Core
├── Channel Manager    # Maneja múltiples canales (Terminal, Telegram, etc.)
├── Skill System       # Sistema de skills extensibles
├── LLM Interface      # Abstracción para diferentes LLMs
└── Memory System      # Memoria persistente de contexto
```

**Configuración (`~/.openclaw/config.json`):**

```json
{
    "llm": {
        "provider": "z-ai",
        "model": "glm-4.7",
        "apiKey": "${ZAI_API_KEY}",
        "baseUrl": "https://api.z.ai/api/paas/v4/",
        "temperature": 0.7,
        "maxTokens": 4096
    },
    "channels": {
        "enabled": ["terminal", "telegram"],
        "default": "terminal"
    },
    "memory": {
        "type": "persistent",
        "path": ".openclaw/memory.json",
        "maxEntries": 1000
    },
    "skills": {
        "autoLoad": true,
        "directory": ".openclaw/skills"
    }
}
```

### 2.3 MoAI-ADK

**Descripción:** Agentic Development Kit para Claude Code.

**Arquitectura de Agentes:**

| Agente | Especialidad | Función |
|--------|-------------|---------|
| **Alfred** | Orquestación | Coordina otros agentes |
| **Spec** | Especificaciones | Define requisitos |
| **Architect** | Arquitectura | Diseña estructura del proyecto |
| **Frontend** | Frontend | Desarrolla UI/UX |
| **Backend** | Backend | Desarrolla lógica servidor |
| **Database** | Base de datos | Diseña esquemas y queries |
| **Testing** | Testing | Crea pruebas unitarias |
| **DevOps** | DevOps | Configura CI/CD |

**Configuración (`~/.moai/config.json`):**

```json
{
    "llm": {
        "provider": "z-ai",
        "model": "glm-4.7",
        "apiKey": "${ZAI_API_KEY}",
        "baseUrl": "https://api.z.ai/api/paas/v4/"
    },
    "agents": {
        "default": "alfred",
        "timeout": 30000,
        "maxIterations": 10
    },
    "workflow": {
        "mode": "spec-first",
        "autoRefactor": true,
        "testDriven": true
    }
}
```

### 2.4 Pica SDK

**Descripción:** Capa de integración para conectar con APIs SaaS.

**Integraciones soportadas:**
- GitHub, GitLab, Bitbucket
- Google Workspace (Sheets, Docs, Drive)
- Slack, Discord, Microsoft Teams
- Stripe, PayPal
- AWS, GCP, Azure
- Y 26,000+ más

**Uso con Python:**

```python
from openai import OpenAI

client = OpenAI(
    api_key=os.environ.get("PICA_SECRET_KEY"),
    base_url="https://api.picaos.com/v1"
)

# Listar conectores disponibles
connectors = client.connectors.list()

# Usar un conector específico
response = client.tools.run(
    connector="github",
    action="create_repository",
    params={"name": "my-repo", "private": True}
)
```

**Uso con Node.js:**

```javascript
const Pica = require('@picahq/ai');

const pica = new Pica(process.env.PICA_SECRET_KEY);

// Usar integración
await pica.github.createRepository({
    name: 'my-repo',
    private: true
});
```

---

## 3. Flujo de Datos

### 3.1 Ciclo de Vida de una Petición

```
┌─────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Usuario │────▶│ OpenClaw │────▶│ MoAI-ADK │────▶│ GLM-4.7  │
└─────────┘     └─────┬────┘     └─────┬────┘     └─────┬────┘
                     │                 │                 │
                     ▼                 ▼                 │
              ┌──────────┐     ┌──────────┐            │
              │ Pipeline │────▶│ Skills   │────────────┘
              │ de Acción│     │ Agentes  │
              └─────┬────┘     └─────┬────┘
                    │                │
                    ▼                ▼
              ┌──────────┐     ┌──────────┐
              │  Claude  │◀────│  Pica    │
              │  Code    │     │  API     │
              └─────┬────┘     └──────────┘
                    │
                    ▼
              ┌──────────┐
              │ Código   │
              │ Generado │
              └──────────┘
```

### 3.2 Protocolo de Comunicación

**Formato de mensajes (Interno):**

```json
{
    "id": "msg_abc123",
    "timestamp": "2025-02-07T10:30:00Z",
    "source": "telegram",
    "user": "vibecoder",
    "content": {
        "type": "prompt",
        "text": "Crea una función para...",
        "context": {
            "project": "my-app",
            "language": "python",
            "framework": "fastapi"
        }
    },
    "metadata": {
        "priority": "normal",
        "agent": "alfred",
        "maxTokens": 4096
    }
}
```

**Respuesta:**

```json
{
    "id": "resp_xyz789",
    "requestId": "msg_abc123",
    "status": "success",
    "content": {
        "type": "code",
        "language": "python",
        "code": "def my_function():...",
        "explanation": "..."
    },
    "actions": [
        {
            "type": "file_write",
            "path": "src/main.py",
            "status": "completed"
        }
    ]
}
```

---

## 4. Configuración Avanzada

### 4.1 Múltiples LLMs

Configurar fallback entre múltiples proveedores:

```json
{
    "llm": {
        "providers": {
            "primary": {
                "name": "z-ai",
                "model": "glm-4.7",
                "apiKey": "${ZAI_API_KEY}",
                "baseUrl": "https://api.z.ai/api/paas/v4/"
            },
            "fallback": {
                "name": "anthropic",
                "model": "claude-sonnet-4-20250514",
                "apiKey": "${ANTHROPIC_API_KEY}",
                "baseUrl": "https://api.anthropic.com"
            }
        },
        "strategy": "primary_with_fallback",
        "maxRetries": 3
    }
}
```

### 4.2 Configuración de MCP Servers

Model Context Protocol permite extender Claude Code:

```json
{
    "mcpServers": {
        "github": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-github"],
            "env": {
                "GITHUB_TOKEN": "${GITHUB_TOKEN}"
            }
        },
        "filesystem": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/vibecoder/projects"]
        },
        "postgres": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-postgres"],
            "env": {
                "POSTGRES_CONNECTION_STRING": "postgresql://..."
            }
        }
    }
}
```

### 4.3 Configuración de Systemd

Servicio para OpenClaw (`/etc/systemd/system/openclaw.service`):

```ini
[Unit]
Description=OpenClaw AI Assistant
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
User=vibecoder
Group=vibecoder
WorkingDirectory=/home/vibecoder
Environment="PATH=/home/vibecoder/.local/bin:/usr/local/bin:/usr/bin:/bin"
EnvironmentFile=-/home/vibecoder/.vibecoding.env
ExecStart=/usr/bin/openclaw start
ExecStop=/usr/bin/openclaw stop
Restart=always
RestartSec=10
StandardOutput=append:/var/log/vibecoding/openclaw.log
StandardError=append:/var/log/vibecoding/openclaw-error.log

[Install]
WantedBy=multi-user.target
```

### 4.4 Configuración de Nginx (Reverse Proxy)

Para exponer servicios web:

```nginx
upstream vibecoding {
    server 127.0.0.1:3000;
}

server {
    listen 80;
    server_name vibecoding.yourdomain.com;

    location / {
        proxy_pass http://vibecoding;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 5. Integraciones

### 5.1 GitHub Integration

Configurar autenticación:

```bash
# Crear Personal Access Token
# Settings → Developer settings → Personal access tokens → Tokens (classic)

# Configurar en OpenClaw
openclaw config set github.token YOUR_TOKEN
openclaw config set github.username your-username
```

### 5.2 Google Sheets Integration

Con Pica:

```python
from openai import OpenAI

client = OpenAI(
    api_key=PICA_SECRET_KEY,
    base_url="https://api.picaos.com/v1"
)

# Crear hoja de cálculo
spreadsheet = client.tools.run(
    connector="google_sheets",
    action="create_spreadsheet",
    params={
        "title": "Vibecoding Projects",
        "sheets": ["Tasks", "Progress", "Notes"]
    }
)
```

### 5.3 Slack Integration

Webhook configuration:

```bash
# Crear Incoming Webhook en Slack
# https://api.slack.com/messaging/webhooks

# Configurar en OpenClaw
cat >> ~/.openclaw/config.json << EOF
{
    "notifications": {
        "slack": {
            "webhook": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
            "channel": "#vibecoding",
            "events": ["completion", "error"]
        }
    }
}
EOF
```

---

## 6. Seguridad

### 6.1 Gestión de Secrets

Nunca hardcodear API keys en el código:

```bash
# ✅ CORRECTO - Usar variables de entorno
export ZAI_API_KEY="sk-..."
claude

# ❌ INCORRECTO - Hardcodear
claude --api-key sk-...
```

### 6.2 Permisos de Archivos

```bash
# Configurar permisos correctos
chmod 600 ~/.vibecoding.env
chmod 600 ~/.claude/settings.json
chmod 600 ~/.openclaw/config.json
chmod 700 ~/.openclaw/skills
```

### 6.3 Firewall

```bash
# Configurar UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow from YOUR_IP to any port 22
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

### 6.4 SSH Hardening

```bash
# /etc/ssh/sshd_config
Port 2222                    # Cambiar puerto default
PermitRootLogin no
PasswordAuthentication no     # Solo keys
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
```

---

## 7. Rendimiento

### 7.1 Optimización de Memoria

```json
{
    "llm": {
        "cache": {
            "enabled": true,
            "maxSize": 1000,
            "ttl": 3600
        },
        "streaming": true
    }
}
```

### 7.2 Límites de PM2

```javascript
// ecosystem.config.js
module.exports = {
    apps: [{
        name: 'openclaw',
        max_memory_restart: '500M',
        min_uptime: '10s',
        max_restarts: 10,
        restart_delay: 4000
    }]
};
```

### 7.3 Monitoreo

```bash
# Instalar netdata para monitoreo
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Acceder a dashboard
http://your-vps:19999
```

---

## 8. Mantenimiento

### 8.1 Actualización de Componentes

```bash
# Actualizar Claude Code
claude update

# Actualizar OpenClaw
npm update -g openclaw

# Actualizar Skills
cd ~/.openclaw/skills/awesome-openclaw-skills
git pull
```

### 8.2 Rotación de Logs

```bash
# /etc/logrotate.d/vibecoding
/var/log/vibecoding/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 vibecoder vibecoder
    sharedscripts
    postrotate
        pm2 reload openclaw
    endscript
}
```

### 8.3 Backup

```bash
#!/bin/bash
# backup.sh - Script de backup

BACKUP_DIR="/backup/vibecoding"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

# Backup configuraciones
tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" \
    /home/vibecoder/.claude \
    /home/vibecoder/.openclaw \
    /home/vibecoder/.moai \
    /home/vibecoder/.vibecoding.env

# Backup proyectos
tar -czf "$BACKUP_DIR/projects_$DATE.tar.gz" \
    /home/vibecoder/.vibecoding/projects

# Eliminar backups antiguos (>30 días)
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +30 -delete
```

---

## 9. Troubleshooting Avanzado

### 9.1 Modo Debug

```bash
# Habilitar debug logs
export DEBUG=*
export LOG_LEVEL=debug

openclaw start --verbose
```

### 9.2 Análisis de Cuellos de Botella

```bash
# Perfilado de Node.js
node --prof openclaw
node --prof-process isolate-*.log > profile.txt

# Análisis de memoria
node --heap-prof openclaw
```

### 9.3 Recuperación de Desastres

```bash
# Si OpenClaw no inicia
pm2 delete openclaw
pm2 save --force
openclaw start

# Si hay corrupción de datos
cd ~/.openclaw
git checkout config.json
```

---

## 10. API Reference

### 10.1 OpenClaw CLI

```bash
# Comandos disponibles
openclaw start          # Iniciar servicio
openclaw stop           # Detener servicio
openclaw restart        # Reiniciar servicio
openclaw status         # Ver estado
openclaw logs           # Ver logs
openclaw config         # Gestionar configuración
openclaw skill list     # Listar skills
openclaw skill install  # Instalar skill
openclaw onboard        # Configuración inicial
```

### 10.2 Claude Code CLI

```bash
# Comandos principales
claude                  # Iniciar sesión interactiva
claude /moai:project    # Iniciar proyecto MoAI
claude /config          # Configurar
claude --version        # Versión
claude update           # Actualizar
```

---

**Versión:** 1.0.0
**Última actualización:** 2025-02-07
