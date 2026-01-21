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
    # Обновление дистрибутива
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf upgrade --refresh -y
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper refresh && sudo zypper update -y
    elif command -v apk >/dev/null 2>&1; then
        sudo apk update && sudo apk upgrade
    else
        echo "❌ Неизвестный пакетный менеджер. Обновление не выполнено."
        return 1
    fi

    # Обновление твоего проекта
    if [ -d "$HOME/.config/irovbyte" ]; then
        echo "🔄 Updating irovbyte configs..."
        git -C "$HOME/.config/irovbyte" pull --rebase
    fi

    # Перезапуск Zsh
    exec zsh
}