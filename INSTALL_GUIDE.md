#  Guía de Instalación Paso a Paso

##  Contenido

1. [Requisitos Previos](#1-requisitos-previos)
2. [Obtención de API Keys](#2-obtención-de-api-keys)
3. [Preparación del VPS](#3-preparación-del-vps)
4. [Instalación Automática](#4-instalación-automática)
5. [Instalación Manual](#5-instalación-manual)
6. [Instalación con Docker](#6-instalación-con-docker)
7. [Post-Instalación](#7-post-instalación)
8. [Solución de Problemas](#8-solución-de-problemas)

---

## 1. Requisitos Previos

### 1.1 Hardware Mínimo

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| CPU | 2 vCPU | 4+ vCPU |
| RAM | 4 GB | 8 GB |
| Disco | 20 GB | 50 GB SSD |
| Ancho de banda | 10 Mbps | 100 Mbps |

### 1.2 Sistema Operativo

- **Ubuntu 22.04 LTS** (recomendado)
- **Ubuntu 24.04 LTS**
- **Debian 11+**
- **Otras distribuciones Linux** (puede requerir adaptaciones)

### 1.3 Software Necesario

El script de instalación instalará automáticamente:
- Git
- Node.js 18+
- Python 3.10+
- npm
- ripgrep
- ffmpeg
- jq

---

## 2. Obtención de API Keys

### 2.1 Z.AI API Key (GLM-4.7)

**¿Qué es?** API para usar el modelo GLM-4.7, una alternativa económica a Claude.

**Pasos:**

1. Visita [https://docs.z.ai/guides/llm/glm-4.7](https://docs.z.ai/guides/llm/glm-4.7)

2. Haz clic en "Get Started" o regístrate

3. Navega a [https://docs.bigmodel.cn/cn/coding-plan/overview](https://docs.bigmodel.cn/cn/coding-plan/overview)

4. Elige un plan:
   - **GLM Coding Lite**: ~$3/mes (120 prompts cada 5 horas)
   - **GLM Coding Pro**: ~$15/mes (para uso intensivo)

5. Copia tu API Key desde el dashboard

**Guarda tu key:** `ZAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxx`

### 2.2 Pica Secret Key

**¿Qué es?** Plataforma de integración para conectar con 26,000+ APIs SaaS.

**Pasos:**

1. Visita [https://docs.picaos.com/get-started/quickstart](https://docs.picaos.com/get-started/quickstart)

2. Regístrate o inicia sesión

3. Ve a la sección de API Keys

4. Crea una nueva API Key

**Guarda tu key:** `PICA_SECRET_KEY=pk_xxxxxxxxxxxxxxxxxxxxxx`

### 2.3 Telegram Bot Token (Opcional)

**¿Qué es?** Para interactuar con OpenClaw vía Telegram.

**Pasos:**

1. Abre Telegram y busca [@BotFather](https://t.me/BotFather)

2. Envía `/newbot`

3. Sigue las instrucciones para nombrar tu bot

4. Copia el token que BotFather te da

**Guarda tu token:** `TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz`

### 2.4 Claude API Key (Opcional)

**¿Qué es?** API oficial de Anthropic para Claude (más costoso que GLM-4.7).

**Pasos:**

1. Visita [https://console.anthropic.com](https://console.anthropic.com)

2. Regístrate y verifica tu teléfono

3. Ve a API Keys

4. Crea una nueva key

---

## 3. Preparación del VPS

### 3.1 Acceder al VPS

```bash
# Via SSH con password
ssh root@tu-ip-vps

# Via SSH con key (más seguro)
ssh -i /ruta/a/tu-key.pem root@tu-ip-vps
```

### 3.2 Actualizar el Sistema

```bash
apt update && apt upgrade -y
```

### 3.3 Configurar TimeZone (Opcional)

```bash
# Para México
timedatectl set-timezone America/Cancun

# Verificar
date
```

### 3.4 Crear Directorio de Trabajo

```bash
mkdir -p /opt/vibecoding
cd /opt/vibecoding
```

---

## 4. Instalación Automática

### 4.1 Descargar el Instalador

```bash
# Clonar desde GitHub
git clone https://github.com/softvibeslab/softvibes_vibecoding.git
cd softvibes_vibecoding

# O descargar directamente
wget https://github.com/softvibeslab/softvibes_vibecoding/archive/refs/heads/main.zip
unzip main.zip
cd softvibes_vibecoding-main
```

### 4.2 Preparar Archivo de Entorno

```bash
# Copiar el template
cp .env.example .vibecoding.env

# Editar con tus credenciales
nano .vibecoding.env
```

**Contenido mínimo a editar:**

```bash
ZAI_API_KEY=tu_api_key_aqui
PICA_SECRET_KEY=tu_pica_key_aqui
TELEGRAM_BOT_TOKEN=tu_token_aqui   # opcional
```

### 4.3 Ejecutar el Script de Instalación

```bash
# Hacer ejecutable
chmod +x install.sh

# Ejecutar con sudo
sudo ./install.sh
```

### 4.4 Durante la Instalación

El script te pedirá:

```
═══════════════════════════════════════════════════════════════════════════════
                    Vibecoding Ecosystem Installer v1.0.0
═══════════════════════════════════════════════════════════════════════════════

→ Ingresa tu Z.AI API Key: [pegar aquí]
→ Ingresa tu Pica Secret Key: [pegar aquí]
→ Ingresa tu Telegram Bot Token (opcional): [pegar aquí o Enter]
→ Nombre de usuario no-root (default: vibecoder): [Enter para usar default]

¿Continuar con esta configuración? (y/n): y
```

### 4.5 Proceso de Instalación

El script realizará automáticamente:

```
[INFO] Actualizando sistema...
[INFO] Instalando dependencias base (curl, git, nodejs, python3...)
[INFO] Creando usuario vibecoder...
[INFO] Instalando Claude Code...
[INFO] Instalando OpenClaw...
[INFO] Instalando MoAI-ADK...
[INFO] Instalando Pica SDK...
[INFO] Instalando Awesome-OpenClaw-Skills...
[INFO] Instalando PM2...
[INFO] Configurando firewall...
[INFO] Creando aliases y atajos...
[INFO] Creando servicios systemd...
```

**Tiempo estimado:** 15-30 minutos (depende de la conexión)

---

## 5. Instalación Manual

Si prefieres instalar componente por componente:

### 5.1 Crear Usuario

```bash
adduser vibecoder
usermod -aG sudo vibecoder
echo "vibecoder ALL=(ALL) NOPASSWD:/usr/bin/systemctl,/usr/bin/pm2" > /etc/sudoers.d/vibecoder
```

### 5.2 Instalar Dependencias

```bash
apt update
apt install -y curl git python3-pip nodejs npm build-essential ripgrep ffmpeg jq ufw
```

### 5.3 Instalar Node.js LTS

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs
```

### 5.4 Instalar Claude Code

```bash
# Como usuario vibecoder
su - vibecoder
curl -fsSL https://claude.ai/install.sh | bash

# Configurar
mkdir -p ~/.claude
cat > ~/.claude/settings.json << EOF
{
    "autoUpdatesChannel": "latest"
}
EOF
```

### 5.5 Instalar OpenClaw

```bash
# Aún como vibecoder
npm install -g openclaw@latest

# Configurar
mkdir -p ~/.openclaw
cat > ~/.openclaw/config.json << EOF
{
    "llm": {
        "provider": "z-ai",
        "model": "glm-4.7",
        "apiKey": "$ZAI_API_KEY",
        "baseUrl": "https://api.z.ai/api/paas/v4/"
    }
}
EOF
```

### 5.6 Instalar PM2

```bash
npm install -g pm2
pm2 startup systemd -u vibecoder --hp /home/vibecoder
```

### 5.7 Instalar Skills

```bash
mkdir -p ~/.openclaw/skills
cd ~/.openclaw/skills
git clone https://github.com/VoltAgent/awesome-openclaw-skills.git

# Instalar skills clave
npx clawhub@latest install claude-code
npx clawhub@latest install git-github
```

---

## 6. Instalación con Docker

### 6.1 Instalar Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker vibecoder
```

### 6.2 Instalar Docker Compose

```bash
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 6.3 Configurar Entorno

```bash
cd /opt/vibecoding/softvibes_vibecoding
cp .env.example .vibecoding.env
nano .vibecoding.env  # Editar con tus API keys
```

### 6.4 Construir y Ejecutar

```bash
# Construir imagen
docker-compose build

# Ejecutar en detached mode
docker-compose up -d

# Ver logs
docker-compose logs -f

# Entrar al contenedor
docker-compose exec vibecoding bash
```

### 6.5 Servicios Adicionales

```bash
# Con PostgreSQL
docker-compose --profile with-db up -d

# Con Redis
docker-compose --profile with-redis up -d

# Con todo
docker-compose --profile with-db --profile with-redis up -d
```

---

## 7. Post-Instalación

### 7.1 Verificar Instalación

```bash
# Ejecutar script de verificación
./verify.sh
```

**Salida esperada:**

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    VIBECODING ECOSYSTEM VERIFICATION                        ║
╚══════════════════════════════════════════════════════════════════════════════╝

▶ SYSTEM REQUIREMENTS
  ✓ OS: ubuntu
  ✓ RAM: 4096MB

▶ CORE DEPENDENCIES
  ✓ Node.js: v22.0.0
  ✓ Python3: 3.12.0
  ✓ Git: 2.43.0

▶ VIBECODING COMPONENTS
  ✓ Claude Code: 1.0.58
  ✓ OpenClaw: installed
  ✓ PM2: 5.3.0

Status: ✓ Installation looks good!
```

### 7.2 Recargar Shell

```bash
# Salir y volver a entrar como vibecoder
exit
su - vibecoder

# O recargar bashrc
source ~/.bashrc
```

### 7.3 Probar Claude Code

```bash
# Crear un proyecto de prueba
mkdir ~/test-project
cd ~/test-project

# Iniciar Claude Code
claude

# Dentro de Claude, probar:
"Hola, crea una función Python que calcule fibonacci"
```

### 7.4 Probar OpenClaw

```bash
# Iniciar OpenClaw
openclaw start

# En otra terminal, verificar
pm2 list

# Ver logs
pm2 logs openclaw
```

### 7.5 Configurar Telegram (si aplica)

```bash
# En Telegram, busca tu bot y envía:
/start

# Verificar que OpenClaw responde
```

---

## 8. Solución de Problemas

### 8.1 Claude Code no se encuentra

**Síntoma:** `claude: command not found`

**Solución:**

```bash
# Verificar instalación
ls -la ~/.local/bin/claude

# Agregar a PATH si no está
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 8.2 Error de conexión con Z.AI

**Síntoma:** Error al usar GLM-4.7

**Solución:**

```bash
# Verificar API key
echo $ZAI_API_KEY

# Probar conexión manualmente
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"glm-4.7","messages":[{"role":"user","content":"Hola"}]}'
```

### 8.3 OpenClaw no inicia

**Síntoma:** PM2 muestra status "errored"

**Solución:**

```bash
# Ver logs
pm2 logs openclaw --lines 50

# Reconfigurar
openclaw onboard --reconfigure

# Reiniciar
pm2 restart openclaw
```

### 8.4 Permisos insuficientes

**Síntoma:** Permission denied

**Solución:**

```bash
# Asegurarse de usar el usuario correcto
whoami  # Debe ser vibecoder

# Si es root, cambiar
su - vibecoder
```

### 8.5 Firewall bloqueando conexiones

**Síntoma:** No se puede conectar a APIs externas

**Solución:**

```bash
# Verificar estado de UFW
ufw status

# Permitir conexiones salientes (si está bloqueado)
ufw allow out 80/tcp
ufw allow out 443/tcp

# Permitir SSH
ufw allow OpenSSH
```

### 8.6 Espacio en disco insuficiente

**Síntoma:** Error durante instalación por falta de espacio

**Solución:**

```bash
# Ver espacio disponible
df -h

# Limpiar caché de apt
apt clean
apt autoclean

# Limpiar logs antiguos
journalctl --vacuum-time=7d
```

---

## 9. Próximos Pasos

Una vez completada la instalación:

1. Lee el [Manual de Usuario](USER_MANUAL.md) para aprender a usar el sistema
2. Consulta el [Manual Técnico](TECHNICAL_MANUAL.md) para了解 arquitectura
3. Explora los [Skills disponibles](https://github.com/VoltAgent/awesome-openclaw-skills)
4. Únete a la comunidad de Vibecoding

---

## 10. Soporte

- **GitHub Issues:** [https://github.com/softvibeslab/softvibes_vibecoding/issues](https://github.com/softvibeslab/softvibes_vibecoding/issues)
- **Documentación:** [https://code.claude.com/docs](https://code.claude.com/docs)
- **Comunidad:** [OpenClaw Discord](https://discord.gg/openclaw)

---

**Versión:** 1.0.0
**Última actualización:** 2025-02-07
