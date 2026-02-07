#  Manual de Usuario - Vibecoding Ecosystem

##  Contenido

1. [Introducción](#1-introducción)
2. [Primeros Pasos](#2-primeros-pasos)
3. [Uso de Claude Code](#3-uso-de-claude-code)
4. [Uso de OpenClaw](#4-uso-de-openclaw)
5. [Uso de MoAI-ADK](#5-uso-de-moai-adk)
6. [Workflows de Vibecoding](#6-workflows-de-vibecoding)
7. [Ejemplos Prácticos](#7-ejemplos-prácticos)
8. [Tips y Trucos](#8-tips-y-trucos)
9. [Preguntas Frecuentes](#9-preguntas-frecuentes)

---

## 1. Introducción

### 1.1 ¿Qué es Vibecoding?

**Vibecoding** es una metodología de desarrollo de software donde describes lo que quieres crear en lenguaje natural, y la IA se encarga de generar, refinar y ejecutar el código automáticamente.

**En lugar de:**
```python
# Escribir código manualmente
def calculate_sum(a, b):
    return a + b
```

**En Vibecoding:**
```
"Crea una función que sume dos números y maneje errores"
```

### 1.2 Conceptos Básicos

| Concepto | Descripción |
|----------|-------------|
| **Prompt** | Descripción en lenguaje natural de lo que quieres crear |
| **Agente** | IA especializada en una tarea específica (frontend, backend, testing) |
| **Skill** | Capacidad adicional que puedes instalar a OpenClaw |
| **Iteración** | Proceso de refinar el código mediante conversación con la IA |
| **SPEC** | Especificación detallada de lo que se va a desarrollar |

### 1.3 Canales de Interacción

Puedes interactuar con el ecosistema a través de:

- **Terminal**: Comando `claude` directamente en tu VPS
- **Telegram**: Via bot de OpenClaw
- **WhatsApp**: Via integración de OpenClaw
- **Web**: Interfaz web (opcional)

---

## 2. Primeros Pasos

### 2.1 Iniciar Tu Primera Sesión

```bash
# Acceder a tu VPS
ssh vibecoder@tu-ip-vps

# Crear un directorio para tu proyecto
mkdir ~/mi-primer-proyecto
cd ~/mi-primer-proyecto

# Iniciar Claude Code
claude
```

### 2.2 Primer Prompt

Dentro de Claude Code, prueba:

```
Hola, soy nuevo en Vibecoding. ¿Qué puedes hacer por mí?
```

Claude te responderá con una lista de capacidades.

### 2.3 Configurar Tu Entorno

```bash
# Ver alias disponibles
alias | grep vibe

# Recargar configuración
source ~/.bashrc

# Ver estado del sistema
vibe-status
```

---

## 3. Uso de Claude Code

### 3.1 Interfaz Básica

```
┌─────────────────────────────────────────────────────────────────┐
│  ~/mi-proyecto $                                                │
│                                                                 │
│  💬 Tu prompt:                                                  │
│  └─> Crea una API REST con FastAPI                             │
│                                                                 │
│  🤖 Claude:                                                    │
│  └─> Entendido. Voy a crear una API REST con FastAPI           │
│      que incluye:                                               │
│      - Endpoints CRUD                                           │
│      - Validación con Pydantic                                 │
│      - Documentación automática                                 │
│                                                                 │
│      [Generando archivos...]                                    │
│      ✓ main.py creado                                          │
│      ✓ models.py creado                                        │
│      ✓ requirements.txt creado                                 │
│                                                                 │
│      ¿Quieres que agregue algo más?                            │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Comandos Especiales

Dentro de Claude Code, puedes usar comandos especiales:

| Comando | Descripción |
|---------|-------------|
| `/moai:project` | Iniciar un proyecto con MoAI |
| `/moai:alfred` | Usar el agente orquestador |
| `/config` | Abrir configuración |
| `/help` | Ver ayuda |
| `Ctrl+C` | Cancelar operación actual |
| `Ctrl+D` | Salir de Claude |

### 3.3 Iteración en el Código

Claude Code te permite iterar sobre el código generado:

```
💬 Tú: Ahora agrega autenticación JWT
🤖 Claude: Agregaré autenticación JWT a tu API...

💬 Tú: El endpoint de login no funciona bien
🤖 Claude: Déjame revisar el endpoint de login...
          [Detecta el error y lo corrige]

💬 Tú: Agrega tests unitarios
🤖 Claude: Crearé tests con pytest...
```

### 3.4 Modos de Claude Code

```bash
# Modo interactivo (default)
claude

# Modo rápido para una sola pregunta
claude "¿Qué significa este error?"

# Modo específico con archivo
claude main.py "Explica este código"
```

---

## 4. Uso de OpenClaw

### 4.1 Iniciar OpenClaw

```bash
# Iniciar el servicio
openclaw start

# Verificar que está corriendo
pm2 list

# Ver logs en tiempo real
pm2 logs openclaw
```

### 4.2 Configurar Telegram

1. **Crear un Bot:**
   - Abre Telegram y busca [@BotFather](https://t.me/BotFather)
   - Envía `/newbot`
   - Sigue las instrucciones
   - Copia el token

2. **Conectar tu Bot:**
   ```bash
   openclaw config --channel telegram --token TU_TOKEN
   ```

3. **Usar tu Bot:**
   - Busca tu bot en Telegram
   - Envía `/start`
   - ¡Listo! Puedes chatear con tu asistente IA

### 4.3 Comandos de OpenClaw en Chat

| Comando | Descripción |
|---------|-------------|
| `/start` | Iniciar conversación |
| `/help` | Ver comandos disponibles |
| `/status` | Ver estado del sistema |
| `/code` | Generar código |
| `/run` | Ejecutar comando |
| `/git` | Operaciones de Git |

### 4.4 Ejemplo de Sesión en Telegram

```
Tú: /code
Bot: ¿Qué código quieres que genere?

Tú: Una función Python para scrapear una web
Bot: [Genera código de web scraping]

Tú: /run
Bot: ¿Qué comando quieres ejecutar?

Tú: python scraper.py
Bot: [Ejecuta y muestra el resultado]
```

---

## 5. Uso de MoAI-ADK

### 5.1 Iniciar un Proyecto MoAI

```bash
cd tu-proyecto
claude /moai:project
```

Esto iniciará el workflow de MoAI:

```
╔═══════════════════════════════════════════════════════════════════╗
║                    MoAI Project Setup                             ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  1. ¿Qué quieres construir?                                       ║
║     └─> Una app web de e-commerce                                ║
║                                                                   ║
║  2. ¿Qué tecnologías prefieres?                                   ║
║     └─> React, Node.js, MongoDB                                  ║
║                                                                   ║
║  3. Generando SPEC del proyecto...                                ║
║     ✓ Especificación creada                                       ║
║                                                                   ║
║  4. Creando estructura del proyecto...                            ║
║     ✓ Directorios creados                                        ║
║     ✓ Archivos base generados                                    ║
║                                                                   ║
║  [SPEC saved to: .moai/project.spec]                             ║
╚═══════════════════════════════════════════════════════════════════╝
```

### 5.2 Agentes Disponibles

```bash
# Usar agente de arquitectura
claude /moai:architect "Diseña la arquitectura para un sistema de chat"

# Usar agente de frontend
claude /moai:frontend "Crea el componente de login"

# Usar agente de testing
claude /moai:testing "Agrega tests para el módulo de usuarios"

# Usar orquestador Alfred
claude /moai:alfred "Coordina la creación de un feature completo"
```

### 5.3 Workflow SPEC-First

MoAI sigue un enfoque SPEC-First:

1. **Especificar**: Definir qué se va a construir
2. **Diseñar**: Planear la arquitectura
3. **Implementar**: Generar el código
4. **Probar**: Verificar que funciona
5. **Refactor**: Mejorar la calidad

```bash
# Crear SPEC
claude "Crea un SPEC para un módulo de pagos"

# Revisar SPEC
cat .moai/payment.spec

# Implementar desde SPEC
claude /moai:implement "Implementa el SPEC de pagos"

# Probar
claude /moai:testing "Crea tests para el módulo de pagos"
```

---

## 6. Workflows de Vibecoding

### 6.1 Workflow Básico

```
┌────────────────┐
│  1. Idea       │ "Quiero una app para guardar notas"
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  2. Prompt     │ En Claude Code: "Crea una app de notas con React"
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  3. Generación │ Claude genera estructura y código
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  4. Revisión   │ Revisas el código generado
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  5. Iteración  │ "Agrega modo oscuro"
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  6. Prueba     │ npm start y probar
└───────┬────────┘
        │
        ▼
┌────────────────┐
│  7. Deploy     │ "Deploy a Vercel"
└────────────────┘
```

### 6.2 Workflow con MoAI

```bash
# 1. Iniciar proyecto
mkdir ~/mi-app && cd ~/mi-app
claude /moai:project

# 2. Definir requisitos
"Quiero una app de gestión de tareas con:
- Usuarios con auth
- Listas de tareas
- Recordatorios
- Modo offline"

# 3. Dejar que MoAI orqueste
# Alfred coordinará a los agentes:
# - Architect: Diseña la arquitectura
# - Database: Diseña el schema
# - Backend: Crea la API
# - Frontend: Crea la UI

# 4. Revisar SPEC
cat .moai/project.spec

# 5. Implementar
claude /moai:alfred "Implementa todo el proyecto"

# 6. Probar
claude /moai:testing "Crea suite de tests completa"
```

### 6.3 Workflow con OpenClaw (Telegram)

```
Tú: /code
Bot: ¿Qué necesitas?

Tú: Una API de clima con FastAPI
Bot: [Genera código de API]

Tú: Agrega documentación
Bot: [Agrega Swagger UI]

Tú: /run
Bot: ¿Qué comando?

Tú: uvicorn main:app --reload
Bot: [Ejecuta y muestra logs]

Tú: /git
Bot: ¿Qué operación de Git?

Tú: commit "Initial commit"
Bot: [Hace commit del código]
```

---

## 7. Ejemplos Prácticos

### 7.1 Crear una API REST

**Prompt:**
```
Crea una API REST con FastAPI que tenga:
- Endpoints para crear, leer, actualizar y eliminar usuarios
- Validación con Pydantic
- Base de datos SQLite
- Documentación automática
```

**Resultado esperado:**
- `main.py` - Aplicación FastAPI
- `models.py` - Modelos Pydantic
- `database.py` - Configuración de BD
- `requirements.txt` - Dependencias

### 7.2 Crear un Frontend con React

**Prompt:**
```
Crea una app con React que tenga:
- Login de usuarios
- Dashboard con gráficos
- Lista de productos
- Carrito de compras
```

**Resultado esperado:**
- Estructura de componentes React
- Hooks personalizados
- Integración con API
- Estilos con Tailwind CSS

### 7.3 Automatizar una Tarea

**Prompt (en OpenClaw):**
```
/run git add .
/run git commit -m "Update code"
/run git push origin main
```

### 7.4 Scraping Web

**Prompt:**
```
Crea un script en Python que:
- Scrapee noticias de un sitio web
- Las guarde en un archivo CSV
- Use BeautifulSoup
```

---

## 8. Tips y Trucos

### 8.1 Prompts Efectivos

**❌ Mal prompt:**
```
"Haz código"
```

**✅ Buen prompt:**
```
"Crea una función en Python que calcule el factorial de un número.
Incluye manejo de errores para números negativos y
documentación con docstrings."
```

### 8.2 Iteración Eficiente

1. **Sé específico**: "Agrega X" es mejor que "Mejora esto"
2. **Divide tareas**: En lugar de "Haz todo", pide "Primero haz X, luego Y"
3. **Verifica antes de pedir más**: Revisa el código antes de pedir cambios
4. **Usa el contexto**: Claude recuerda la conversación, úsalo a tu favor

### 8.3 Atajos de Teclado

| Teclado | Acción |
|---------|--------|
| `Ctrl+C` | Cancelar generación |
| `Ctrl+D` | Salir de Claude |
| `Ctrl+L` | Limpiar pantalla |
| `↑ / ↓` | Navegar historial de prompts |

### 8.4 Aliases Útiles

Ya están configurados en tu sistema:

```bash
vibecode    # Equivalente a: claude
vclaw       # Equivalente a: openclaw
vmoai       # Equivalente a: moai
vlogs       # Ver logs en tiempo real
vibe-status # Estado del sistema
```

---

## 9. Preguntas Frecuentes

### 9.1 General

**P: ¿Necesito saber programar para usar Vibecoding?**
R: No es necesario, pero entender conceptos básicos te ayudará a dar mejores prompts.

**P: ¿Puedo usarlo para proyectos comerciales?**
R: Sí, el código generado es tuyo y puedes usarlo como gustes.

**P: ¿Cuánto cuesta?**
R: Depende de tu uso. GLM-4.7 cuesta desde $3/mes, significativamente menos que Claude Pro.

### 9.2 Técnico

**P: ¿Qué modelos de lenguaje puedo usar?**
R: Puedes usar GLM-4.7 (Z.AI), Claude (Anthropic), o cualquier modelo compatible con OpenAI.

**P: ¿Mi código es privado?**
R: Sí, todo se ejecuta en tu VPS. Tu código nunca sale de tu sistema.

**P: ¿Puedo conectarme a mi propio repositorio?**
R: Sí, puedes configurar GitHub/GitLab para que OpenClaw haga commits y push automáticamente.

### 9.3 Troubleshooting

**P: Claude Code no responde**
R: Presiona `Ctrl+C` y vuelve a intentar. Si persiste, verifica tu API key.

**P: OpenClaw no inicia**
R: Verifica los logs con `pm2 logs openclaw` y reinicia con `pm2 restart openclaw`.

**P: Error de "rate limit"**
R: Espera unos minutos o actualiza tu plan de Z.AI.

---

## 10. Glosario

| Término | Definición |
|---------|------------|
| **Agentico** | Sistema que usa agentes IA especializados |
| **Iteration** | Ciclo de mejora mediante feedback |
| **LLM** | Large Language Model (Modelo de Lenguaje Grande) |
| **MCP** | Model Context Protocol |
| **Prompt** | Instrucción en lenguaje natural |
| **Skill** | Módulo de funcionalidad para OpenClaw |
| **SPEC** | Especificación detallada de requisitos |
| **TDD** | Test-Driven Development (Desarrollo Guiado por Tests) |
| **Vibecoding** | Desarrollo de software asistido por IA |

---

## 11. Recursos Adicionales

- **Guía de Instalación:** [INSTALL_GUIDE.md](INSTALL_GUIDE.md)
- **Manual Técnico:** [TECHNICAL_MANUAL.md](TECHNICAL_MANUAL.md)
- **Claude Code Docs:** [https://code.claude.com/docs](https://code.claude.com/docs)
- **MoAI-ADK GitHub:** [https://github.com/modu-ai/moai-adk](https://github.com/modu-ai/moai-adk)
- **OpenClaw GitHub:** [https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)

---

**Versión:** 1.0.0
**Última actualización:** 2025-02-07

¡Feliz Vibecoding! 🚀
