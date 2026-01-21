#!/bin/sh

echo "🔍 Проверка базовых инструментов..."

# ============================================================
# 1. Проверка sudo (важно для ArchWSL)
# ============================================================
if ! command -v sudo >/dev/null 2>&1; then
    echo "❌ sudo не найден."
    printf "📥 Установить sudo сейчас? (y/n): "
    read install_sudo

    if [ "$install_sudo" = "y" ] || [ "$install_sudo" = "Y" ]; then
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

# ============================================================
# 2. Проверка curl
# ============================================================
if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl не установлен."
    printf "📥 Установить curl сейчас? (y/n): "
    read install_curl

    if [ "$install_curl" = "y" ] || [ "$install_curl" = "Y" ]; then
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

    if [ "$install_git" = "y" ] || [ "$install_git" = "Y" ]; then
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

    if [ "$install_zsh" = "y" ] || [ "$install_zsh" = "Y" ]; then
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