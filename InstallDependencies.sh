#!/bin/bash

echo "🔍 Проверка базовых инструментов..."

# ============================================================
# Универсальная функция установки пакета
# ============================================================
install_pkg() {
    local pkg="$1"

    if command -v apt >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            apt update && apt install -y "$pkg"
        else
            sudo apt update && sudo apt install -y "$pkg"
        fi

    elif command -v pacman >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            pacman -Syu --noconfirm
            pacman -S --noconfirm "$pkg"
        else
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm "$pkg"
        fi

    elif command -v dnf >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            dnf install -y "$pkg"
        else
            sudo dnf install -y "$pkg"
        fi

    elif command -v zypper >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            zypper install -y "$pkg"
        else
            sudo zypper install -y "$pkg"
        fi

    elif command -v apk >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            apk add "$pkg"
        else
            sudo apk add "$pkg"
        fi

    else
        echo "❌ Неизвестный дистрибутив."
        exit 1
    fi
}

# ============================================================
# Проверка sudo (root не нуждается)
# ============================================================
if [ "$(id -u)" -eq 0 ]; then
    echo "⚠️ Запуск под root — sudo не требуется."
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "❌ sudo не найден."
        printf "📥 Установить sudo сейчас? (y/n): "
        read ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            install_pkg sudo
            echo "✅ sudo установлен!"
        else
            echo "⛔ sudo обязателен для установки."
            exit 1
        fi
    fi
fi

# ============================================================
# Проверка curl
# ============================================================
if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl не установлен."
    printf "📥 Установить curl сейчас? (y/n): "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg curl
        echo "✅ curl установлен!"
    else
        echo "⛔ curl обязателен."
        exit 1
    fi
fi

# ============================================================
# Проверка git
# ============================================================
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git не установлен."
    printf "📥 Установить git сейчас? (y/n): "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg git
        echo "✅ Git установлен!"
    else
        echo "⛔ Git обязателен."
        exit 1
    fi
fi

# ============================================================
# Проверка zsh
# ============================================================
if ! command -v zsh >/dev/null 2>&1; then
    echo "❌ Zsh не установлен."
    printf "📥 Установить zsh сейчас? (y/n): "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg zsh
        echo "✅ Zsh установлен!"
    else
        echo "⛔ Zsh обязателен."
        exit 1
    fi
fi

echo "✅ Все базовые инструменты установлены!"
echo "🔍 Определение дистрибутива..."

# ============================================================
# Основная установка
# ============================================================
install_packages() {
    install_pkg zsh
    install_pkg git
    install_pkg curl
}

install_oh_my_zsh() {
    echo "⚙️ Установка Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_powerlevel10k() {
    echo "🎨 Установка Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
}

install_plugins() {
    echo "✨ Установка плагинов..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
}

echo "🚀 Начинаю установку зависимостей..."
install_packages
install_oh_my_zsh
install_powerlevel10k
install_plugins

echo "✅ Установка зависимостей завершена!"
echo "🚀 Запуск конфигурации..."

bash -c "$(curl -fsSL https://raw.githubusercontent.com/irovbyte/CustomTerminals/main/InstallConfig.sh)"