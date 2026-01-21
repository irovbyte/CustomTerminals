# ============================================================
# irovbyte global config file
# ============================================================

# Цвета
BOLD="\e[1m"
RESET="\e[0m"
CYAN="\e[1;36m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
MAGENTA="\e[1;35m"

# -----------------------------
# Алиасы
# -----------------------------
alias lsa='ls -lah --group-directories-first --color=auto'
alias zshp='exec zsh'
alias zshedit='code ~/.zshrc'
alias sys='uname -a && echo "" && lsb_release -a 2>/dev/null || cat /etc/os-release'

# -----------------------------
# Открытие Проводника Windows
# -----------------------------
open() {
    if [ -z "$1" ]; then
        explorer.exe .
    else
        explorer.exe "$1"
    fi
}

# -----------------------------
# Умное обновление проекта irovbyte
# -----------------------------
update() {
    # Определяем sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        SUDO="sudo"
    fi

    # 1) Обновление системы
    if command -v apt >/dev/null 2>&1; then
        $SUDO apt update && $SUDO apt upgrade -y && $SUDO apt autoremove -y
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -Syu --noconfirm
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf upgrade --refresh -y
    elif command -v zypper >/dev/null 2>&1; then
        $SUDO zypper refresh && $SUDO zypper update -y
    elif command -v apk >/dev/null 2>&1; then
        $SUDO apk update && $SUDO apk upgrade
    fi

    echo -e "${CYAN}🔍 Проверка обновлений конфигов irovbyte...${RESET}"

    REPO="irovbyte/CustomTerminals"
    API_URL="https://api.github.com/repos/$REPO/commits/main"
    LOCAL_VERSION_FILE="$HOME/.config/irovbyte/.version"

    # Получаем SHA последнего коммита
    LATEST_SHA=$(curl -s "$API_URL" | grep '"sha"' | head -n 1 | cut -d '"' -f 4)

    if [ -z "$LATEST_SHA" ]; then
        echo -e "${RED}❌ Не удалось получить информацию о последнем коммите.${RESET}"
        return 1
    fi

    # Локальная версия
    if [ ! -f "$LOCAL_VERSION_FILE" ]; then
        LOCAL_SHA="none"
    else
        LOCAL_SHA=$(cat "$LOCAL_VERSION_FILE")
    fi

    # Если SHA совпадают — обновлять не нужно
    if [ "$LOCAL_SHA" = "$LATEST_SHA" ]; then
        echo -e "${GREEN}✔ Конфиги уже актуальны. Новых обновлений нет.${RESET}"
        exec zsh
        return 0
    fi

    echo -e "${CYAN}🔄 Обновление конфигов irovbyte...${RESET}"

    TEMP_DIR="$HOME/.irovbyte-update-temp"
    REPO_URL="https://github.com/$REPO"

    rm -rf "$TEMP_DIR"
    git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

    mkdir -p "$HOME/.config/irovbyte"

    # Обновляем все конфиги
    [ -f "$TEMP_DIR/config.zsh" ] && cp "$TEMP_DIR/config.zsh" "$HOME/.config/irovbyte/config.zsh"
    [ -f "$TEMP_DIR/UnixLike/Zsh/.zshrc" ] && cp "$TEMP_DIR/UnixLike/Zsh/.zshrc" "$HOME/.zshrc"
    [ -f "$TEMP_DIR/UnixLike/Zsh/.p10k.zsh" ] && cp "$TEMP_DIR/UnixLike/Zsh/.p10k.zsh" "$HOME/.p10k.zsh"

    # Сохраняем новый SHA
    echo "$LATEST_SHA" > "$LOCAL_VERSION_FILE"

    rm -rf "$TEMP_DIR"

    echo -e "${GREEN}✨ Конфиги обновлены до последней версии!${RESET}"

    exec zsh
}

# -----------------------------
# Полное удаление irovbyte (uninstall)
# -----------------------------
irovremove() {
    echo -e "${RED}${BOLD}⚠️ ВНИМАНИЕ: будет удалён весь irovbyte-config!${RESET}"
    echo -e "${YELLOW}Удалятся файлы:${RESET}"
    echo -e "  • ~/.config/irovbyte"
    echo -e "  • ~/.zshrc"
    echo -e "  • ~/.p10k.zsh"
    echo ""

    read -p "Продолжить? (y/n): " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.config/irovbyte"
        rm -f "$HOME/.zshrc"
        rm -f "$HOME/.p10k.zsh"
        echo -e "${GREEN}✔ irovbyte полностью удалён.${RESET}"
        exec zsh
    else
        echo -e "${CYAN}Отмена удаления.${RESET}"
    fi
}

#-----------------------------
# Справка по irovbyte-utils
#-----------------------------
helpirov() {
    echo -e "\e[1;36m==============================\e[0m"
    echo -e "\e[1;36m   Справка по irovbyte-utils  \e[0m"
    echo -e "\e[1;36m==============================\e[0m"
    echo ""
    printf "%-15s %-50s\n" "Команда" "Описание"
    printf "%-15s %-50s\n" "-------" "---------"

    printf "%-15s %-50s\n" "lsa" "красивый вывод файлов"
    printf "%-15s %-50s\n" "zshp" "перезапуск Zsh"
    printf "%-15s %-50s\n" "zshedit" "открыть .zshrc в VS Code"
    printf "%-15s %-50s\n" "open" "открыть Проводник Windows"
    printf "%-15s %-50s\n" "update" "авто‑обновление системы и конфигов"
    printf "%-15s %-50s\n" "sys" "информация о системе и дистрибутиве"
    printf "%-15s %-50s\n" "irovremove" "полное удаление irovbyte-конфигов"
    printf "%-15s %-50s\n" "helpirov" "показать эту справку"

    echo ""
    echo -e "\e[1;32mГотово! Используй команды с кайфом.\e[0m"
}