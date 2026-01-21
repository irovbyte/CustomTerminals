#!/bin/bash

echo "🔍 Проверка базовых инструментов..."

# ============================================================
# 1. Проверка sudo (root не нуждается в sudo)
# ============================================================
if [ "$(id -u)" -eq 0 ]; then
    echo "⚠️ Запуск под root — sudo не требуется. Пропускаю проверку sudo."
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "❌ sudo не найден."
        printf "📥 Установить sudo сейчас? (y/n): "
        read install_sudo

        if [[ "$install_sudo" =~ ^[Yy]$ ]]; then
            echo "🔧 Устанавливаю sudo..."

            if command -v apt >/dev/null 2>&1; then
                apt update && apt install -y sudo
            elif command -v pacman >/dev/null 2>&1; then
                pacman -Syu --noconfirm
                pacman -S --noconfirm sudo
            elif command -v dnf >/dev/null 2>&1; then
                dnf install -y sudo
            elif command -v zypper >/dev/null 2>&1; then
                zypper install -y sudo
            elif command -v apk >/dev/null 2>&1; then
                apk add sudo
            else
                echo "❌ Неизвестный дистрибутив. Установка sudo невозможна."
                exit 1
            fi

            echo "✅ sudo установлен!"
        else
            echo "⛔ sudo не установлен. Продолжение невозможно."
            exit 1
        fi
    fi
fi

# ============================================================
# 2. Проверка curl
# ============================================================
if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl не установлен."
    printf "📥 Установить curl сейчас? (y/n): "
    read install_curl

    if [[ "$install_curl" =~ ^[Yy]$ ]]; then
        echo "🔧 Устанавливаю curl..."

        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y curl
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm curl
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y curl
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y curl
        elif command -v apk >/dev/null 2>&1; then
            sudo apk add curl
        else
            echo "❌ Неизвестный дистрибутив. Установка curl невозможна."
            exit 1
        fi

        echo "✅ curl установлен!"
    else
        echo "⛔ curl не установлен. Продолжение невозможно."
        exit 1
    fi
fi

# ============================================================
# 3. Проверка git
# ============================================================
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git не установлен."
    printf "📥 Установить git сейчас? (y/n): "
    read install_git

    if [[ "$install_git" =~ ^[Yy]$ ]]; then
        echo "🔧 Устанавливаю git..."

        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y git
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm git
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y git
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y git
        elif command -v apk >/dev/null 2>&1; then
            sudo apk add git
        else
            echo "❌ Неизвестный дистрибутив. Установка git невозможна."
            exit 1
        fi

        echo "✅ Git установлен!"
    else
        echo "⛔ Git не установлен. Продолжение невозможно."
        exit 1
    fi
fi

# ============================================================
# 4. Проверка zsh
# ============================================================
if ! command -v zsh >/dev/null 2>&1; then
    echo "❌ Zsh не установлен."
    printf "📥 Установить zsh сейчас? (y/n): "
    read install_zsh

    if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
        echo "🔧 Устанавливаю zsh..."

        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y zsh
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm zsh
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y zsh
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y zsh
        elif command -v apk >/dev/null 2>&1; then
            sudo apk add zsh
        else
            echo "❌ Неизвестный дистрибутив. Установка zsh невозможна."
            exit 1
        fi

        echo "✅ Zsh установлен!"
    else
        echo "⛔ Zsh не установлен. Продолжение невозможно."
        exit 1
    fi
fi

echo "✅ Все базовые инструменты установлены!"
echo "🔍 Определение дистрибутива..."

# ============================================================
# ОСНОВНОЙ БЛОК УСТАНОВКИ
# ============================================================

install_packages() {
    if command -v apt >/dev/null 2>&1; then
        echo "📦 Обнаружен Ubuntu/Debian (apt)"
        sudo apt update
        sudo apt install -y zsh git curl

    elif command -v pacman >/dev/null 2>&1; then
        echo "📦 Обнаружен Arch/Manjaro (pacman)"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm zsh git curl

    elif command -v dnf >/dev/null 2>&1; then
        echo "📦 Обнаружен Fedora (dnf)"
        sudo dnf install -y zsh git curl

    elif command -v zypper >/dev/null 2>&1; then
        echo "📦 Обнаружен openSUSE (zypper)"
        sudo zypper install -y zsh git curl

    elif command -v apk >/dev/null 2>&1; then
        echo "📦 Обнаружен Alpine (apk)"
        sudo apk add zsh git curl

    else
        echo "❌ Неизвестный дистрибутив. Установка невозможна."
        exit 1
    fi
}

install_oh_my_zsh() {
    echo "⚙️ Установка Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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