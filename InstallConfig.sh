#!/bin/bash

# Цвета
BOLD="\e[1m"
RESET="\e[0m"
CYAN="\e[1;36m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
MAGENTA="\e[1;35m"

echo -e "${CYAN}🎛 Установка конфигурации Zsh от irovbyte...${RESET}"

# Проверка git
if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}❌ Git не установлен. Установите git через пакетный менеджер.${RESET}"
    exit 1
fi

# Проверка zsh
if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${RED}❌ Zsh не установлен. Установите zsh перед запуском конфигурации.${RESET}"
    exit 1
fi

TEMP_DIR="$HOME/.customterminals-temp"
REPO_URL="https://github.com/irovbyte/CustomTerminals"

echo -e "${CYAN}📥 Скачивание репозитория...${RESET}"
rm -rf "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR" || {
    echo -e "${RED}❌ Ошибка скачивания репозитория!${RESET}"
    exit 1
}

ZSH_DIR="$TEMP_DIR/UnixLike/Zsh"
CONFIG_SRC="$TEMP_DIR/config.zsh"
CONFIG_DEST="$HOME/.config/irovbyte"

# Проверка наличия .zshrc
if [ ! -f "$ZSH_DIR/.zshrc" ]; then
    echo -e "${RED}❌ Файл .zshrc не найден в репозитории!${RESET}"
    exit 1
fi

echo -e "${MAGENTA}⚙️ Установка .zshrc...${RESET}"
cp "$ZSH_DIR/.zshrc" "$HOME/.zshrc"

echo -e "${MAGENTA}⚙️ Установка config.zsh...${RESET}"
rm -rf "$CONFIG_DEST"
mkdir -p "$CONFIG_DEST"
cp "$CONFIG_SRC" "$CONFIG_DEST/config.zsh"

echo ""
echo -e "${CYAN}🎨 Выберите стиль Powerlevel10k:${RESET}"
echo -e "${BOLD}1)${RESET} Установить готовую тему irovbyte"
echo -e "${BOLD}2)${RESET} Настроить Powerlevel10k вручную (p10k configure)"
echo ""
printf "${BOLD}Ваш выбор: ${RESET}"
read STYLE

if [ "$STYLE" = "1" ]; then
    if [ -f "$ZSH_DIR/.p10k.zsh" ]; then
        cp "$ZSH_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
        echo -e "${GREEN}✨ Установлена тема irovbyte.${RESET}"
    else
        echo -e "${RED}❌ Файл .p10k.zsh не найден!${RESET}"
    fi
else
    echo -e "${MAGENTA}🛠 Запуск конфигуратора Powerlevel10k...${RESET}"
    rm -f "$HOME/.p10k.zsh" 2>/dev/null || true
    rm -f "$HOME/.zshrc.zwc" 2>/dev/null || true
    exec zsh -c "p10k configure"
fi

echo -e "${YELLOW}🧹 Очистка временных файлов...${RESET}"
rm -rf "$TEMP_DIR"

echo -e "${GREEN}🚀 Конфигурация завершена! Запуск Zsh...${RESET}"
exec zsh