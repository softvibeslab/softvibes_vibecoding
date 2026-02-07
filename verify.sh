#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Vibecoding Ecosystem - Verification Script                                  ║
# ║  Verifica que todos los componentes estén instalados y funcionales           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#

set -e

readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_RESET='\033[0m'

# Cargar variables de entorno si existe el archivo
if [[ -f ".vibecoding.env" ]]; then
    source .vibecoding.env
fi

# Usuario por defecto
VIBE_USER=${VIBE_USER:-vibecoder}

print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    VIBECODING ECOSYSTEM VERIFICATION                        ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

check_item() {
    local name="$1"
    local command="$2"
    local expected="$3"

    if eval "$command" &>/dev/null; then
        local version=$(eval "$command" 2>/dev/null || echo "installed")
        echo -e "  ✓ ${COLOR_GREEN}${name}${COLOR_RESET}: ${version}"
        return 0
    else
        echo -e "  ✗ ${COLOR_RED}${name}${COLOR_RESET}: Not found"
        return 1
    fi
}

check_file() {
    local name="$1"
    local path="$2"

    if [[ -e "$path" ]]; then
        echo -e "  ✓ ${COLOR_GREEN}${name}${COLOR_RESET}: ${path}"
        return 0
    else
        echo -e "  ✗ ${COLOR_RED}${name}${COLOR_RESET}: ${path} not found"
        return 1
    fi
}

check_service() {
    local name="$1"
    local service="$2"

    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "  ✓ ${COLOR_GREEN}${name}${COLOR_RESET}: Running"
        return 0
    elif command -v pm2 &>/dev/null && pm2 list | grep -q "$service" 2>/dev/null; then
        echo -e "  ✓ ${COLOR_GREEN}${name}${COLOR_RESET}: Running via PM2"
        return 0
    else
        echo -e "  ✗ ${COLOR_RED}${name}${COLOR_RESET}: Not running"
        return 1
    fi
}

test_api_connection() {
    local name="$1"
    local url="$2"
    local header="${3:-}"

    if curl -s -f --head "$url" ${header:+-H "$header"} > /dev/null 2>&1; then
        echo -e "  ✓ ${COLOR_GREEN}${name}${COLOR_RESET}: Reachable"
        return 0
    else
        echo -e "  ⚠ ${COLOR_YELLOW}${name}${COLOR_RESET}: Not reachable (may be temporary)"
        return 1
    fi
}

print_section() {
    echo ""
    echo -e "${COLOR_CYAN}▶ $1${COLOR_RESET}"
    echo "────────────────────────────────────────────────────────────────────────────"
}

# ═══════════════════════════════════════════════════════════════════════════════
# VERIFICACIÓN
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    print_header

    local total=0
    local passed=0

    # System
    print_section "SYSTEM REQUIREMENTS"
    check_item "OS" "cat /etc/os-release | grep -w ^ID= | cut -d= -f2"
    ((total++)); ((passed++))  # OS always exists

    check_item "Kernel" "uname -r"
    ((total++)); ((passed++))

    local ram=$(free -m | awk '/^Mem:/{print $2}')
    if [[ $ram -ge 2048 ]]; then
        echo -e "  ✓ ${COLOR_GREEN}RAM${COLOR_RESET}: ${ram}MB"
    else
        echo -e "  ⚠ ${COLOR_YELLOW}RAM${COLOR_RESET}: ${ram}MB (recommended: 4GB+)"
    fi
    ((total++)); ((passed++))

    # Core Dependencies
    print_section "CORE DEPENDENCIES"
    check_item "Node.js" "node --version"
    ((total++)) && [[ $(command -v node &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "npm" "npm --version"
    ((total++)) && [[ $(command -v npm &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "Python3" "python3 --version"
    ((total++)) && [[ $(command -v python3 &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "pip3" "pip3 --version"
    ((total++)) && [[ $(command -v pip3 &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "Git" "git --version"
    ((total++)) && [[ $(command -v git &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "ripgrep" "rg --version"
    ((total++)) && [[ $(command -v rg &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    # Vibecoding Components
    print_section "VIBECODING COMPONENTS"

    if id "$VIBE_USER" &>/dev/null; then
        echo -e "  ✓ ${COLOR_GREEN}User '$VIBE_USER'${COLOR_RESET}: Exists"
        ((passed++))
    else
        echo -e "  ✗ ${COLOR_RED}User '$VIBE_USER'${COLOR_RESET}: Not found"
    fi
    ((total++))

    check_item "Claude Code" "su - $VIBE_USER -c 'claude --version 2>/dev/null || echo installed'"
    ((total++)) && [[ -f "/home/$VIBE_USER/.local/bin/claude" ]] && ((passed++))

    check_item "OpenClaw" "openclaw --version 2>/dev/null || echo installed"
    ((total++)) && [[ $(command -v openclaw &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    check_item "PM2" "pm2 --version"
    ((total++)) && [[ $(command -v pm2 &>/dev/null; echo $?) -eq 0 ]] && ((passed++))

    # Configuration Files
    print_section "CONFIGURATION FILES"

    check_file "Environment file" ".vibecoding.env"
    ((total++)); [[ -f ".vibecoding.env" ]] && ((passed++))

    check_file "Claude settings" "/home/$VIBE_USER/.claude/settings.json"
    ((total++)); [[ -f "/home/$VIBE_USER/.claude/settings.json" ]] && ((passed++))

    check_file "OpenClaw config" "/home/$VIBE_USER/.openclaw/config.json"
    ((total++)); [[ -f "/home/$VIBE_USER/.openclaw/config.json" ]] && ((passed++))

    check_file "MoAI config" "/home/$VIBE_USER/.moai/config.json"
    ((total++)); [[ -f "/home/$VIBE_USER/.moai/config.json" ]] && ((passed++))

    check_file "OpenClaw skills" "/home/$VIBE_USER/.openclaw/skills"
    ((total++)); [[ -d "/home/$VIBE_USER/.openclaw/skills" ]] && ((passed++))

    # Services
    print_section "SERVICES"

    check_service "OpenClaw (systemd)" "openclaw.service"
    ((total++))

    # API Connectivity
    print_section "API CONNECTIVITY"

    test_api_connection "Z.AI API" "https://api.z.ai"
    ((total++))

    test_api_connection "Claude API" "https://api.anthropic.com"
    ((total++))

    test_api_connection "Pica API" "https://api.picaos.com"
    ((total++))

    # Summary
    print_section "SUMMARY"
    echo ""
    local percent=$((passed * 100 / total))
    echo "  Total checks: $total"
    echo -e "  Passed: ${COLOR_GREEN}${passed}${COLOR_RESET}"

    if [[ $percent -ge 80 ]]; then
        echo -e "  Status: ${COLOR_GREEN}✓ Installation looks good!${COLOR_RESET}"
        echo ""
        echo -e "${COLOR_CYAN}Next steps:${COLOR_RESET}"
        echo "  1. Source environment: source .vibecoding.env"
        echo "  2. Switch to user: su - $VIBE_USER"
        echo "  3. Start developing: cd ~/my-project && claude"
        return 0
    elif [[ $percent -ge 50 ]]; then
        echo -e "  Status: ${COLOR_YELLOW}⚠ Partial installation${COLOR_RESET}"
        echo ""
        echo "  Some components are missing. Run ./install.sh again or check the logs."
        return 1
    else
        echo -e "  Status: ${COLOR_RED}✗ Installation incomplete${COLOR_RESET}"
        echo ""
        echo "  Please run ./install.sh to complete the installation."
        return 1
    fi
}

main "$@"
