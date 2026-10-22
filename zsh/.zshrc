# --- Environment Variables ---
export EDITOR='nvim'
export TERM=xterm-256color
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"

export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:$HOME/go/bin"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH="$PATH:/usr/local/bin/python3" # Usually not needed

# --- Oh My Zsh ---
plugins=(
  git
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

# fzf-tab: fuzzy tab completion, Tokyo Night, previews dirs with eza
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' fzf-flags --color=bg:-1,bg+:#292e42,fg:#a9b1d6,fg+:#c0caf5,hl:#7aa2f7,hl+:#7dcfff,pointer:#ff9e64,border:#3b4261
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' popup-min-size 80 12
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'

# --- Tool Initializations ---
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Optional: nvm completion

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # Load bun completions

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" # Load Rust/Cargo env

[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env" # Load Deno env

eval "$(zoxide init --cmd cd zsh)" # Initialize zoxide

# --- zoxide fzf integration ---
zi() {
  local dir
  dir="$(zoxide query -l | fzf --height=40% --border --preview 'eza --tree --color=always {} | head -200')" \
    && cd "$dir"
}


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
alias ls="eza --color=always --icons=always"
alias ll="eza --color=always --long --header --icons=always"

alias update="brew update && brew upgrade"
alias battery="pmset -g batt"
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
alias taudio="yt-dlp -x --audio-format mp3"
alias claw="/Users/apple/old-files/my-projects/claw-code/rust/target/release/claw"
alias spr='mvn spring-boot:run'

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
eval "$(atuin init zsh --disable-up-arrow)" # Ctrl-R history search
eval "$(mise activate zsh)" # per-project tool versions (.mise.toml)

# bun completions
[ -s "/Users/apple/.bun/_bun" ] && source "/Users/apple/.bun/_bun"

export BAT_THEME='Dracula'

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

source /Users/apple/.config/broot/launcher/bash/br

export PATH="/Users/apple/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/apple/.antigravity/antigravity/bin:$PATH"
export GOOGLE_API_KEY="AIzaSyDrKOZym6wSewQSQAIc35NP_EUY4wBLBQ8"
export CLAW_MODEL="gemini-2.5-flash"

# opencode
export PATH=/Users/apple/.opencode/bin:$PATH

alias claude-mem='bun "/Users/apple/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'


# Added by Antigravity CLI installer
export PATH="/Users/apple/.local/bin:$PATH"
export JAVA_HOME=/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home

# pnpm
export PNPM_HOME="/Users/apple/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
