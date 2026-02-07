# 🎓 Vibecoding Onboarding Guide

Guía paso a paso para empezar a usar el ecosistema Vibecoding.

---

## 📋 Índice

1. [Bienvenida](#bienvenida)
2. [Paso 1: Configuración Inicial](#paso-1-configuración-inicial)
3. [Paso 2: Primer Bot](#paso-2-primer-bot)
4. [Paso 3: Primera SPEC](#paso-3-primera-spec)
5. [Paso 4: Primer Proyecto](#paso-4-primer-proyecto)
6. [Paso 5: Integraciones](#paso-5-integraciones)
7. [Recursos de Ayuda](#recursos-de-ayuda)

---

## 👋 Bienvenida

¡Bienvenido a **Vibecoding**! Este ecosistema está diseñado para ayudarte a desarrollar software más rápido usando IA.

**¿Qué puedes hacer?**

- Crear SPECs de proyecto estructuradas
- Generar código con IA
- Automatizar tareas repetitivas
- Integrar APIs externas fácilmente
- Desplegar aplicaciones automáticamente

---

## 🚀 Paso 1: Configuración Inicial

### 1.1 Verificar Instalación

Abre tu terminal y ejecuta:

```bash
vibe-status
```

Deberías ver algo como:

```
=== Vibecoding Status ===
Claude Code: v2.1.34
OpenClaw: v2026.2.6-3
PM2: vibes-bot [online]
```

### 1.2 Iniciar el Bot de Telegram

```bash
pm2 list
```

El bot `vibes-bot` debería estar **online**.

### 1.3 Conectar con el Bot

1. Abre Telegram
2. Busca **@Vibesmck_bot**
3. Envía `/start`

---

## 🤖 Paso 2: Primer Bot

### 2.1 Tu Primer Interacción

Envía este mensaje al bot:

```
Hola Vibes, ¿qué puedes hacer por mí?
```

El bot responderá con un menú de opciones.

### 2.2 Consulta Rápida

Prueba el comando `/ask`:

```
/ask ¿Qué es FastAPI y por qué debería usarlo?
```

**¿Qué pasó?** GLM-4.7 procesó tu pregunta y te dio una respuesta.

### 2.3 Ejecutar un Agente

Prueba el comando `/agent`:

```
/agent Lista los archivos del directorio actual
```

**¿Qué pasó?** OpenClaw ejecutó un agente que listó los archivos.

---

## 📋 Paso 3: Primera SPEC

### 3.1 ¿Qué es una SPEC?

Una **SPEC** (Specification) es un documento estructurado que define:

- **Título**: Nombre de la funcionalidad
- **Descripción**: Qué hace
- **Criterios de Aceptación**: Cómo saber si está lista

### 3.2 Crear tu Primera SPEC

En Telegram, envía:

```
/spec
```

El bot te guiará paso a paso:

**Paso 1 - Título**:
```
Calculadora de Propinas
```

**Paso 2 - Descripción**:
```
Una aplicación simple que calcula propinas basadas en el total de la cuenta y el porcentaje deseado.
```

**Paso 3 - Criterios de Aceptación**:
```
- Calcula propinas correctamente
- Permite porcentajes personalizados
- Muestra el total a pagar
```

### 3.3 Ver tu SPEC

```
/specs
```

Deberías ver tu nueva SPEC listada.

---

## 💻 Paso 4: Primer Proyecto

### 4.1 Iniciar Desarrollo

Ahora que tienes una SPEC, vamos a desarrollarla:

```
/agent Implementa la calculadora de propinas en Python
```

El agente OpenClaw te guiará en la implementación.

### 4.2 Entender el Código

Si no entiendes algo del código:

```
/ask Explica cómo funciona el cálculo de propinas
```

### 4.3 Crear Tests

```
/agent Crea tests unitarios para la calculadora
```

### 4.4 Guardar el Proyecto

Los archivos se guardan automáticamente en:
```
/home/vibecoder/vibecoding-workspace/
```

---

## 🔌 Paso 5: Integraciones

### 5.1 APIs Disponibles

Vibecoding incluye **Pica** para conectar con 26,000+ APIs.

### 5.2 Ver APIs Disponibles

```
/pica list
```

### 5.3 Ejemplo: Integrar Stripe

```
/agent Crea una integración con Stripe para procesar pagos
```

El agente usará Pica para configurar la API.

---

## 📚 Ejercicios Prácticos

### Ejercicio 1: To-Do List

1. Crea una SPEC para una API de To-Do
2. Implementa los endpoints
3. Crea tests
4. Haz deploy local

### Ejercicio 2: Scraper

1. Crea una SPEC para un scraper web
2. Implementa el scraping
3. Exporta datos a CSV

### Ejercicio 3: Bot

1. Crea una SPEC para un bot personalizado
2. Integra con Telegram
3. Deploy a producción

---

## 🎯 Flujos de Trabajo Comunes

### Flujo: Nueva Feature

```
/spec → /agent "plan" → /agent "implement" → /agent "test"
```

### Flujo: Bug Fix

```
/agent "analiza el bug" → /agent "fix" → /agent "verifica"
```

### Flujo: Nuevo Proyecto

```
/spec → /agent "estructura" → /agent "esqueleto" → /agent "desarrollo"
```

---

## 🆘 Recursos de Ayuda

### Comandos de Ayuda

| Comando | Descripción |
|---------|-------------|
| `/help` | Ayuda general |
| `/status` | Estado del sistema |
| `/docs` | Documentación |

### Documentación

- [Guía del Ecosistema](ECOSYSTEM_GUIDE.md)
- [Manual Técnico](TECHNICAL_MANUAL.md)
- [Manual de Usuario](USER_MANUAL.md)
- [Guía de Instalación](INSTALL_GUIDE.md)

### Soporte

- GitHub Issues: [softvibeslab/softvibes_vibecoding](https://github.com/softvibeslab/softvibes_vibecoding/issues)

---

## 🎓 Certificación Vibecoding

Completa estos ejercicios para certificarte:

1. ✅ Crear 3 SPECs diferentes
2. ✅ Implementar 2 proyectos completos
3. ✅ Integrar al menos 2 APIs externas
4. ✅ Hacer deploy de una aplicación

---

## 🎉 ¡Felicidades!

Has completado el onboarding básico de Vibecoding.

**¿Qué sigue?**

- Explora las [Skills](https://github.com/anthropics/awesome-openclaw-skills)
- Conéctate con la comunidad
- Construye proyectos increíbles

---

**Versión**: 1.0.0
**Autor**: Vibecoding Team
**Fecha**: 2026-02-07
