#!/bin/bash

echo "🎛 Установка конфигурации Zsh от irovbyte..."

# Проверка git
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git не установлен. Установите git через пакетный менеджер."
    exit 1
fi

# Проверка zsh
if ! command -v zsh >/dev/null 2>&1; then
    echo "❌ Zsh не установлен. Установите zsh перед запуском конфигурации."
    exit 1
fi

TEMP_DIR="$HOME/.customterminals-temp"
REPO_URL="https://github.com/irovbyte/CustomTerminals"

echo "📥 Скачивание репозитория..."
rm -rf "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR" || {
    echo "❌ Ошибка скачивания репозитория!"
    exit 1
}

ZSH_DIR="$TEMP_DIR/UnixLike/Zsh"
CONFIG_SRC="$TEMP_DIR/config.zsh"
CONFIG_DEST="$HOME/.config/irovbyte"

# Проверка наличия .zshrc
if [ ! -f "$ZSH_DIR/.zshrc" ]; then
    echo "❌ Файл .zshrc не найден в репозитории!"
    exit 1
fi

echo "⚙️ Установка .zshrc..."
cp "$ZSH_DIR/.zshrc" "$HOME/.zshrc"

echo "⚙️ Установка config.zsh..."
rm -rf "$CONFIG_DEST"
mkdir -p "$CONFIG_DEST"
cp "$CONFIG_SRC" "$CONFIG_DEST/config.zsh"

echo ""
echo "🎨 Выберите стиль Powerlevel10k:"
echo "1) Установить готовую тему irovbyte"
echo "2) Настроить Powerlevel10k вручную (p10k configure)"
echo ""
printf "Ваш выбор: "
read STYLE

if [ "$STYLE" = "1" ]; then
    if [ -f "$ZSH_DIR/.p10k.zsh" ]; then
        cp "$ZSH_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
        echo "✨ Установлена тема irovbyte."
    else
        echo "❌ Файл .p10k.zsh не найден!"
    fi
else
    echo "🛠 Запуск конфигуратора Powerlevel10k..."
    rm -f "$HOME/.p10k.zsh" 2>/dev/null || true
    rm -f "$HOME/.zshrc.zwc" 2>/dev/null || true
    exec zsh -c "p10k configure"
fi

echo "🧹 Очистка временных файлов..."
rm -rf "$TEMP_DIR"

echo "🚀 Конфигурация завершена! Запуск Zsh..."
exec zsh