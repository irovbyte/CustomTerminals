# ============================================================
# irovbyte global config file
# ============================================================

# -----------------------------
# Алиасы
# -----------------------------
alias lsa='ls -lah --group-directories-first --color=auto'
alias zshp='exec zsh'
alias zshedit='code ~/.zshrc'

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
# Универсальное обновление системы + обновление irovbyte
# -----------------------------
update() {
    # Определяем sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        SUDO="sudo"
    fi

    # Обновление системы
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
    else
        echo -e "\e[1;31m❌ Неизвестный пакетный менеджер.\e[0m"
    fi

    # Обновление конфигов irovbyte
    echo -e "\e[1;36m🔄 Updating irovbyte configs...\e[0m"

    TEMP_DIR="$HOME/.irovbyte-update-temp"
    REPO_URL="https://github.com/irovbyte/CustomTerminals"

    rm -rf "$TEMP_DIR"
    git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

    mkdir -p "$HOME/.config/irovbyte"
    cp "$TEMP_DIR/config.zsh" "$HOME/.config/irovbyte/config.zsh"

    rm -rf "$TEMP_DIR"

    # Перезапуск Zsh
    exec zsh
}