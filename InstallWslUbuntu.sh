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

echo ""
echo "Выберите стиль Powerlevel10k:"
echo "1) Установить готовую тему irovbyte"
echo "2) Настроить Powerlevel10k вручную (p10k configure)"
echo ""
read -p "Ваш выбор: " STYLE

if [ "$STYLE" = "1" ]; then
    cp "$TEMP_DIR/WSL/UbuntuZsh/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "Установлена тема irovbyte."
else
    echo "Запуск конфигуратора Powerlevel10k..."
    rm -f "$HOME/.p10k.zsh" 2>/dev/null || true
    rm -f "$HOME/.zshrc.zwc" 2>/dev/null || true
    exec zsh -c "p10k configure"
fi

rm -rf "$TEMP_DIR"

echo "Готово! Перезапускаю Zsh..."
exec zsh
