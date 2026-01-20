#!/bin/sh

echo "Установка конфигурации Zsh от irovbyte..."

command -v git >/dev/null 2>&1 || { 
    echo "Git не установлен. Установите git: sudo apt install git"; 
    exit 1; 
}

TEMP_DIR="$HOME/.customterminals-temp"

rm -rf "$TEMP_DIR"

git clone --depth=1 https://github.com/irovbyte/CustomTerminals "$TEMP_DIR"


cp "$TEMP_DIR/WSL/UbuntuZsh/.zshrc" "$HOME/.zshrc"
cp "$TEMP_DIR/WSL/UbuntuZsh/.p10k.zsh" "$HOME/.p10k.zsh" 2>/dev/null || true

rm -rf "$TEMP_DIR"

echo "Готово! Перезапускаю Zsh..."
exec zsh