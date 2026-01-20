# Путь к кастомной папке
ZSH_CUSTOM_DIR="$HOME/CustomTerminals/WSL/UbuntuZsh"

# ============================================================
# 1. Instant Prompt (ускорение загрузки Powerlevel10k)
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# 2. Oh My Zsh — базовая конфигурация
# ============================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ============================================================
# 3. Плагины Oh My Zsh
# ============================================================
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================================
# 4. Powerlevel10k — настройки темы
# ============================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================
# 5. Алиасы (ярлыки)
# ============================================================
alias lsa='ls -lah --group-directories-first --color=auto'
alias zshp='exec zsh'
alias zshedit='code ~/.zshrc'

# ============================================================
# 6. Открытие Проводника Windows
# ============================================================
open() {
    if [ -z "$1" ]; then
        explorer.exe .
    else
        explorer.exe "$1"
    fi
}

# ============================================================
# 7. Обновление системы Ubuntu
# ============================================================
update() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
}
