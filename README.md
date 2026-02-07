#  Vibecoding Ecosystem

> Instalación automatizada del ecosistema completo de **Vibecoding** - Programación asistida por IA con agentes especializados

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![VPS](https://img.shields.io/badge/VPS-Hostinger-green)](https://www.hostinger.com)
[![GLM](https://img.shields.io/badge/LLM-GLM--4.7-orange)](https://docs.z.ai/guides/llm/glm-4.7)

##  ¿Qué es Vibecoding?

**Vibecoding** es un enfoque de programación asistido por IA donde describes ideas o tareas en lenguaje natural, y la IA genera, refina y ejecuta código automáticamente. En lugar de escribir líneas de código manualmente, iteras con prompts para guiar el proceso.

Este ecosistema integra:

| Componente | Descripción |
|------------|-------------|
| **Claude Code** | Herramienta de Anthropic para codificación agentiva |
| **OpenClaw** | Asistente IA personal que corre localmente |
| **MoAI-ADK** | Kit de desarrollo agentico con TDD y refactorización |
| **Z.AI GLM-4.7** | Modelo LLM optimizado para coding (costo-efectivo) |
| **Pica** | Capa de integración para 26,000+ APIs SaaS |
| **Awesome Skills** | +1,700 skills pre-construidos para OpenClaw |

##  Requisitos Previos

- **Sistema Operativo**: Ubuntu 20.04+, Debian 10+, o compatible
- **Hardware**: Mínimo 4GB RAM, 10GB disco libre
- **Acceso**: SSH root al VPS
- **API Keys**:
  - [Z.AI API Key](https://docs.z.ai/guides/llm/glm-4.7) (~$3/mes)
  - [Pica Secret Key](https://docs.picaos.com) (gratis/por uso)

##  Instalación Rápida

### Opción 1: Script Automatizado (Recomendado)

```bash
# 1. Descargar el instalador
git clone https://github.com/tu-repo/vibecoding-ecosystem.git
cd vibecoding-ecosystem

# 2. Hacer ejecutable el script
chmod +x install.sh

# 3. Ejecutar instalación
sudo ./install.sh
```

El script te pedirá:
- Z.AI API Key
- Pica Secret Key
- Telegram Bot Token (opcional)
- Nombre de usuario (default: `vibecoder`)

### Opción 2: Docker / Docker Compose

```bash
# 1. Copiar y renombrar archivo de entorno
cp .env.example .vibecoding.env

# 2. Editar con tus API keys
nano .vibecoding.env

# 3. Ejecutar con Docker Compose
docker-compose up -d

# 4. Entrar al contenedor
docker-compose exec vibecoding bash
```

##  Estructura de Directorios

```
~/.vibecoding/          # Directorio principal de Vibecoding
├── projects/           # Tus proyectos
├── pica_example.py     # Ejemplo de integración Pica

~/.claude/              # Configuración de Claude Code
├── settings.json       # Configuración principal
├── models.json         # Modelos LLM configurados

~/.openclaw/            # Configuración de OpenClaw
├── config.json         # Config principal
├── telegram.json       # Config de Telegram (si aplica)
└── skills/             # Skills instalados
    ├── awesome-openclaw-skills/
    ├── claude-code/
    └── git-github/

~/.moai/               # Configuración de MoAI-ADK
├── config.json         # Config de agentes
```

##  Uso Básico

### Claude Code

```bash
# Iniciar en un proyecto
cd mi-proyecto
claude

# Comandos útiles dentro de Claude
/moai:project          # Iniciar proyecto MoAI
/moai:alfred          # Usar agente Alfred
/config               # Configurar Claude Code
```

### OpenClaw

```bash
# Iniciar OpenClaw
openclaw start

# O usar el alias
vclaw start

# Configurar canal
openclaw config --channel telegram
openclaw config --channel whatsapp
```

### Comandos de Sistema

```bash
# Ver estado de servicios
vibe-status

# Ver logs en tiempo real
vlogs

# Iniciar todo
vibe-start

# Detener todo
vibe-stop
```

##  Configuración de GLM-4.7

GLM-4.7 es una alternativa económica a Claude con excelente rendimiento en coding:

### Obtener API Key

1. Visita [Z.AI](https://docs.z.ai/guides/llm/glm-4.7)
2. Regístrate y obtén el **Coding Plan** (desde $3/mes)
3. Copia tu API Key

### Configurar con Claude Code

```bash
# Editar configuración
nano ~/.claude/models.json
```

```json
{
  "providers": {
    "z-ai": {
      "baseUrl": "https://api.z.ai/api/paas/v4/",
      "models": ["glm-4.7", "glm-4.7-flash", "glm-4.7-flashx"]
    }
  },
  "defaultModel": "glm-4.7"
}
```

### Usar con OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    api_key="tu-zai-api-key",
    base_url="https://api.z.ai/api/paas/v4/"
)

response = client.chat.completions.create(
    model="glm-4.7",
    messages=[{"role": "user", "content": "Escribe una función Python"}]
)
```

##  Workflow de Vibecoding

### 1. Describe la Idea

En OpenClaw (Telegram/WhatsApp) o Claude Code:

```
"Crea una app web de tracking de hábitos con React frontend,
Node backend, y Google Sheets para guardar datos"
```

### 2. Generación Agentica

El sistema automáticamente:
- Analiza el requerimiento (MoAI-ADK)
- Genera el código (Claude Code + GLM-4.7)
- Integra APIs (Pica)
- Crea el repositorio (Skills de Git)

### 3. Iteración

```
"Refactoriza el código para usar TypeScript"
"Agrega tests unitarios"
"Fija el bug en el login"
```

### 4. Despliegue

```
"Deploy a Vercel"
"Crear PR en GitHub"
```

##  Skills Útiles

Instalar skills adicionales:

```bash
# Listar skills disponibles
npx clawhub@latest list

# Instalar skill específico
npx clawhub@latest install claude-code
npx clawhub@latest install git-github
npx clawhub@latest install devops-cloud
npx clawhub@latest install web-dev
```

##  Solución de Problemas

### Claude Code no encontrado

```bash
# Recargar PATH
source ~/.bashrc

# O verificar instalación
which claude
ls -la ~/.local/bin/claude
```

### Error de conexión con GLM-4.7

```bash
# Verificar API key
echo $ZAI_API_KEY

# Probar conexión
curl -X POST "https://api.z.ai/api/paas/v4/chat/completions" \
  -H "Authorization: Bearer $ZAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"glm-4.7","messages":[{"role":"user","content":"Hola"}]}'
```

### OpenClaw no inicia

```bash
# Ver logs
pm2 logs openclaw

# Reiniciar
pm2 restart openclaw

# Reconfigurar
openclaw onboard --reconfigure
```

### Usar OpenRouter como proxy

Si hay problemas de conectividad directa:

```bash
# Editar configuración
nano ~/.claude/models.json
```

```json
{
  "providers": {
    "openrouter": {
      "baseUrl": "https://openrouter.ai/api/v1",
      "models": ["zhipu-ai/glm-4.7"]
    }
  }
}
```

##  Verificación de Instalación

```bash
# Ejecutar verificación completa
./verify.sh
```

Salida esperada:

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    VIBECODING ECOSYSTEM VERIFICATION                        ║
╚══════════════════════════════════════════════════════════════════════════════╝

▶ SYSTEM REQUIREMENTS
────────────────────────────────────────────────────────────────────────────
  ✓ OS: ubuntu
  ✓ Kernel: 6.8.0-90-generic
  ✓ RAM: 4096MB

▶ CORE DEPENDENCIES
────────────────────────────────────────────────────────────────────────────
  ✓ Node.js: v22.0.0
  ✓ npm: 10.0.0
  ✓ Python3: 3.12.0
  ✓ Git: 2.43.0

▶ VIBECODING COMPONENTS
────────────────────────────────────────────────────────────────────────────
  ✓ User 'vibecoder': Exists
  ✓ Claude Code: 1.0.58
  ✓ OpenClaw: installed
  ✓ PM2: 5.3.0
```

##  Documentación Externa

- [Claude Code Docs](https://code.claude.com/docs)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [MoAI-ADK GitHub](https://github.com/modu-ai/moai-adk)
- [Z.AI GLM-4.7 Docs](https://docs.z.ai/guides/llm/glm-4.7)
- [Pica Documentation](https://docs.picaos.com)
- [Awesome OpenClaw Skills](https://github.com/VoltAgent/awesome-openclaw-skills)

##  Contribuir

Contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-feature`)
3. Commit cambios (`git commit -m 'Añadir nueva feature'`)
4. Push a la rama (`git push origin feature/nueva-feature`)
5. Abre un Pull Request

##  Licencia

MIT License - ver archivo [LICENSE](LICENSE) para detalles.

---

**Hecho con  para la comunidad de Vibecoding**

*Sources:*
- [Set up Claude Code](https://code.claude.com/docs/en/setup)
- [GLM-4.7 Overview](https://docs.z.ai/guides/llm/glm-4.7)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Pica Documentation](https://docs.picaos.com)
- [MoAI-ADK GitHub](https://github.com/modu-ai/moai-adk)
- [Awesome OpenClaw Skills](https://github.com/VoltAgent/awesome-openclaw-skills)
