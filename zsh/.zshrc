# --- Environment Variables ---
export EDITOR='nvim'
export TERM=xterm-256color
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"

export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PNPM_HOME:$PATH" # Add PNPM to PATH if not already present
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:/home/tsegaye/Documents/dev/flutter_linux_3.16.5-stable/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# export PATH="$PATH:/usr/local/bin/python3" # Usually not needed

export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"

# --- Oh My Zsh ---
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

# --- Tool Initializations ---
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Optional: nvm completion

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # Load bun completions

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" # Load Rust/Cargo env

[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env" # Load Deno env

eval "$(zoxide init zsh)" # Initialize zoxide

eval $(thefuck --alias)   # Initialize thefuck
eval $(thefuck --alias fk) # Optional: shorter alias for thefuck

# --- fzf Configuration ---
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  [ -f "${ZDOTDIR:-$HOME}/.fzf.zsh" ] && source "${ZDOTDIR:-$HOME}/.fzf.zsh"

  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

  # fzf-git.sh integration
  if [ -f "$HOME/fzf-git.sh/fzf-git.sh" ]; then
    source "$HOME/fzf-git.sh/fzf-git.sh"
  fi
fi

# --- Aliases ---
alias l="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ls="eza --color=always --icons=always"
alias ll="eza --color=always --long --header --git --icons=always"
alias la="eza --color=always --long --header --git --icons=always --all"
alias lt="eza --color=always --long --tree --level=2 --icons=always"

alias update="sudo apt update && sudo apt upgrade -y"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias curljson='curl -H "Content-Type: application/json"'

alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git checkout"
alias gcm="git commit -m"
alias gs="git status -sb"
alias gf="git fetch"
alias gpl="git pull"
alias gp="git push"
alias gl="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gdc="git diff --cached"

# --- Functions ---
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# --- Prompt Setup (Starship) ---
eval "$(starship init zsh)"

