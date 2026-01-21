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
    # Определяем, root или нет
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        SUDO="sudo"
    fi

    # Обновление дистрибутива
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
        echo -e "\e[1;31m❌ Неизвестный пакетный менеджер. Обновление не выполнено.\e[0m"
        return 1
    fi

    if [ -d "$HOME/.config/irovbyte" ]; then
        echo -e "\e[1;36m🔄 Updating irovbyte configs...\e[0m"
        git -C "$HOME/.config/irovbyte" pull --rebase
    fi

    # Перезапуск Zsh
    exec zsh
}