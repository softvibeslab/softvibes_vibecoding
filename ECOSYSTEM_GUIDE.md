# 🦞 Vibecoding Ecosystem Guide

Guía completa del ecosistema Vibecoding para desarrollo asistido por IA.

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura](#arquitectura)
3. [Componentes](#componentes)
4. [Flujo de Trabajo](#flujo-de-trabajo)
5. [Comandos del Bot](#comandos-del-bot)
6. [Ejemplos Prácticos](#ejemplos-prácticos)

---

## 🚀 Introducción

**Vibecoding** es un ecosistema de programación asistida por IA que combina múltiples herramientas para crear un entorno de desarrollo completo y automatizado.

### Filosofía

```
SPEC-First → Agent Development → API Integration → Deployment
```

1. **SPEC-First Development**: Definir requerimientos antes de código
2. **Agent-Based**: Usar agentes especializados para cada tarea
3. **API-First**: Integración con servicios externa vía Pica
4. **Automation**: Automatizar tareas repetitivas

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Telegram (@Vibesmck_bot)                     │
│                            Interface de Usuario                     │
└──────────────────────────────────────┬──────────────────────────────┘
                                       │
┌──────────────────────────────────────┴──────────────────────────────┐
│                         Vibes Orchestrator V2                       │
│                    (Capa de Orquestación)                           │
├──────────────────┬──────────────────┬──────────────────┬────────────┤
│                  │                  │                  │            │
▼                  ▼                  ▼                  ▼            ▼
┌────────────┐  ┌────────────┐   ┌────────────┐   ┌────────────┐  ┌─────────┐
│   GLM-4.7  │  │  OpenClaw  │   │  MoAI-ADK  │   │   Pica    │  │ Skills  │
│  (Z.AI)    │  │  Gateway   │   │  Workspace │   │   APIs    │  │ 1700+   │
│  LLM       │  │  Agentes   │   │  SPECs     │   │   26K+     │  │         │
└────────────┘  └────────────┘   └────────────┘   └────────────┘  └─────────┘
     │               │                  │                │
     └───────────────┴──────────────────┴────────────────┘
                        │
                ┌───────┴────────┐
                ▼                ▼
          ┌─────────┐      ┌──────────┐
          │ Código  │      │  Deploy  │
          └─────────┘      └──────────┘
```

---

## 🧩 Componentes

### 1. GLM-4.7 (Z.AI)

**Propósito**: Modelo de lenguaje para respuestas rápidas y generación de código.

**Endpoint**: `https://api.z.ai/api/coding/paas/v4`

**Características**:
- 73.8% en SWE-bench
- Soporte para razonamiento complejo
- Optimizado para código

**Uso**:
```bash
/ask "¿Cómo implemento autenticación JWT en FastAPI?"
```

### 2. OpenClaw Gateway

**Propósito**: Sistema de agentes y automatización.

**Puerto**: `18789`

**Características**:
- 1700+ skills pre-instaladas
- Agentes especializados
- Integración con múltiples canales

**Uso**:
```bash
/agent "Analiza el código en src/ y sugiere mejoras"
```

### 3. MoAI-ADK

**Propósito**: SPEC-First Development Kit.

**Workspace**: `/home/vibecoder/vibecoding-workspace`

**Características**:
- Especificaciones estructuradas
- Alfred SuperAgent
- Integración con Claude Code

**Uso**:
```bash
/spec  # Comando interactivo para crear SPECs
```

### 4. Pica

**Propósito**: Integración con 26,000+ APIs externas.

**API Key**: Configurada en entorno

**Características**:
- APIs de pago, comunicación, productividad
- Integración unificada
- Manejo de autenticación

**Uso**:
```python
from pica_handler import PicaHandler
pica = PicaHandler()
pica.call_api("stripe", "charges", {"amount": 1000})
```

### 5. Awesome OpenClaw Skills

**Propósito**: Colección de skills pre-construidas.

**Ubicación**: `/home/vibecoder/.openclaw/skills/`

**Categorías**:
- Desarrollo
- DevOps
- Data Science
- Automatización

---

## 🔄 Flujo de Trabajo

### Flujo Completo de Desarrollo

```
1. IDEACIÓN (Telegram)
   │
   │  "Quiero crear una API de tareas"
   │
   ▼
2. SPEC CREATION (MoAI-ADK)
   │
   │  /spec
   │  → Título: "Task Management API"
   │  → Descripción: "API REST para gestionar tareas"
   │  → Criterios: "CRUD de tareas"
   │
   ▼
3. PLANIFICACIÓN (OpenClaw Agent)
   │
   │  /agent "Crea el plan de implementación"
   │
   ▼
4. DESARROLLO (Claude Code + Skills)
   │
   │  /agent "Implementa los endpoints"
   │
   ▼
5. INTEGRACIÓN (Pica)
   │
   │  /agent "Conecta con Stripe para pagos"
   │
   ▼
6. TESTING (OpenClaw)
   │
   │  /agent "Crea tests unitarios"
   │
   ▼
7. DEPLOY (OpenClaw + Skills)
   │
   │  /agent "Deploy a VPS"
```

---

## 📱 Comandos del Bot

### Comandos Básicos

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/start` | Iniciar el bot | `/start` |
| `/status` | Estado del ecosistema | `/status` |
| `/help` | Ayuda general | `/help` |

### SPEC Management

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/spec` | Crear SPEC (interactivo) | `/spec` |
| `/specs` | Listar SPECs existentes | `/specs` |
| `/spec show <id>` | Ver SPEC específica | `/spec show task-api` |

### Desarrollo

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/agent <cmd>` | Ejecutar agente OpenClaw | `/agent "Crea tests"` |
| `/ask <q>` | Preguntar a GLM-4.7 | `/ask "¿Qué es FastAPI?"` |
| `/develop <spec>` | Iniciar desarrollo de SPEC | `/develop task-api` |

### Integraciones

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/pica list` | Listar APIs disponibles | `/pica list` |
| `/pica call <api>` | Llamar API específica | `/pica call stripe` |

---

## 💡 Ejemplos Prácticos

### Ejemplo 1: Crear una API REST

```bash
# Paso 1: Crear SPEC
/spec
→ Título: "User Management API"
→ Descripción: "API REST para gestionar usuarios"
→ Criterios: "CRUD, autenticación, validación"

# Paso 2: Planificar
/agent "Crea el plan de implementación para User Management API"

# Paso 3: Desarrollar
/develop user-management-api

# Paso 4: Test
/agent "Crea tests para la API de usuarios"
```

### Ejemplo 2: Scraper Web

```bash
# Paso 1: Crear SPEC
/spec
→ Título: "Web Scraper"
→ Descripción: "Scraper de precios de Amazon"
→ Criterios: "Exporta a CSV, maneja paginación"

# Paso 2: Desarrollar
/develop web-scraper

# Paso 3: Deploy
/agent "Deploy scraper como cron job"
```

### Ejemplo 3: Bot de Telegram

```bash
# Paso 1: Crear SPEC
/spec
→ Título: "Telegram Bot"
→ Descripción: "Bot que responde preguntas frecuentes"
→ Criterios: "NLP, respuestas contextuales"

# Paso 2: Integrar OpenAI
/agent "Integra OpenAI API para NLP"

# Paso 3: Deploy
/agent "Deploy a Railway"
```

---

## 🔧 Configuración

### Archivos de Configuración

```bash
# OpenClaw
~/.openclaw/openclaw.json

# MoAI-ADK
~/vibecoding-workspace/.moai/config/

# Bot
~/.vibecoder/.vibecoding/integrated/

# Claude Code
~/.vibecoder/.claude/
```

### Variables de Entorno

```bash
# Z.AI
export ZAI_API_KEY="tu_api_key"

# Pica
export PICA_SECRET_KEY="tu_secret_key"

# Telegram
export TELEGRAM_BOT_TOKEN="tu_token"
```

---

## 📚 Recursos Adicionales

- [OpenClaw Docs](https://docs.openclaw.ai/)
- [MoAI-ADK Docs](https://docs.moai.ai/)
- [Z.AI/GLM](https://docs.z.ai/)
- [Pica](https://pica.cloud/docs/)

---

## 🆘 Troubleshooting

### Bot no responde

```bash
pm2 logs vibes-bot
pm2 restart vibes-bot
```

### OpenClaw no responde

```bash
openclaw health
openclaw gateway restart
```

### MoAI-ADK no crea SPECs

```bash
cd ~/vibecoding-workspace
moai doctor
```

---

**Versión**: 1.0.0
**Última actualización**: 2026-02-07
