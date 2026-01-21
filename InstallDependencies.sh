#!/bin/bash

# Цвета
BOLD="\e[1m"
RESET="\e[0m"
CYAN="\e[1;36m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
MAGENTA="\e[1;35m"

echo -e "${CYAN}🔍 Проверка базовых инструментов...${RESET}"

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
        echo -e "${RED}❌ Неизвестный дистрибутив.${RESET}"
        exit 1
    fi
}

# ============================================================
# Проверка sudo (root не нуждается)
# ============================================================
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${YELLOW}⚠️ Запуск под root — sudo не требуется.${RESET}"
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo -e "${RED}❌ sudo не найден.${RESET}"
        printf "${BOLD}📥 Установить sudo сейчас? (y/n): ${RESET}"
        read ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            install_pkg sudo
            echo -e "${GREEN}✅ sudo установлен!${RESET}"
        else
            echo -e "${RED}⛔ sudo обязателен для установки.${RESET}"
            exit 1
        fi
    fi
fi

# ============================================================
# Проверка curl
# ============================================================
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}❌ curl не установлен.${RESET}"
    printf "${BOLD}📥 Установить curl сейчас? (y/n): ${RESET}"
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg curl
        echo -e "${GREEN}✅ curl установлен!${RESET}"
    else
        echo -e "${RED}⛔ curl обязателен.${RESET}"
        exit 1
    fi
fi

# ============================================================
# Проверка git
# ============================================================
if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}❌ Git не установлен.${RESET}"
    printf "${BOLD}📥 Установить git сейчас? (y/n): ${RESET}"
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg git
        echo -e "${GREEN}✅ Git установлен!${RESET}"
    else
        echo -e "${RED}⛔ Git обязателен.${RESET}"
        exit 1
    fi
fi

# ============================================================
# Проверка zsh
# ============================================================
if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${RED}❌ Zsh не установлен.${RESET}"
    printf "${BOLD}📥 Установить zsh сейчас? (y/n): ${RESET}"
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        install_pkg zsh
        echo -e "${GREEN}✅ Zsh установлен!${RESET}"
    else
        echo -e "${RED}⛔ Zsh обязателен.${RESET}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Все базовые инструменты установлены!${RESET}"
echo -e "${CYAN}🔍 Определение дистрибутива...${RESET}"

# ============================================================
# Основная установка
# ============================================================
install_packages() {
    install_pkg zsh
    install_pkg git
    install_pkg curl
}

install_oh_my_zsh() {
    echo -e "${MAGENTA}⚙️ Установка Oh My Zsh...${RESET}"
    export RUNZSH=no
    export CHSH=no
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_powerlevel10k() {
    echo -e "${MAGENTA}🎨 Установка Powerlevel10k...${RESET}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
}

install_plugins() {
    echo -e "${MAGENTA}✨ Установка плагинов...${RESET}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
}

echo -e "${MAGENTA}🚀 Начинаю установку зависимостей...${RESET}"
install_packages
install_oh_my_zsh
install_powerlevel10k
install_plugins

echo -e "${GREEN}✅ Установка зависимостей завершена!${RESET}"
echo -e "${MAGENTA}🚀 Запуск конфигурации...${RESET}"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/irovbyte/CustomTerminals/main/InstallConfig.sh)"