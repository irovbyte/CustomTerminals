#!/bin/sh

echo "🔍 Определение дистрибутива..."

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

echo "🚀 Начинаем установку зависимостей..."
install_packages
install_oh_my_zsh
install_powerlevel10k
install_plugins

echo "✅ Установка зависимостей завершена!"
echo "🚀 Запуск конфигурации..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/irovbyte/CustomTerminals/main/InstallConfig.sh)"
