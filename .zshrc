# --- Zinit bootstrap ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Prompt: oh-my-posh (do NOT run Powerlevel10k at the same time) ---
export OMP_CONFIG="$HOME/.config/ohmyposh/base.json"
eval "$(oh-my-posh init zsh --print --config "$OMP_CONFIG")"

# --- ZSH BASIC OPTION ---
setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt completeinword auto_menu list_packed # for completion smarter


# --- Keybindings ---
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- Plugins & completions (order matters) ---
# 1) Extra completions before compinit
zinit ice silent; zinit light zsh-users/zsh-completions

# 2) Initialize completion system
autoload -Uz compinit && compinit

# 3) fzf-tab must come AFTER compinit
zinit ice silent; zinit light Aloxaf/fzf-tab

# 4) Autosuggestions (before syntax-highlighting)
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit ice silent; zinit light zsh-users/zsh-autosuggestions

# 5) Syntax highlighting MUST be the last plugin
zinit ice silent; zinit light zsh-users/zsh-syntax-highlighting

# --- Oh My Zsh snippets (optional) ---
zinit ice silent; zinit snippet OMZL::git.zsh
zinit ice silent; zinit snippet OMZP::git
zinit ice silent; zinit snippet OMZP::sudo
# zinit ice silent; zinit snippet OMZP::aws
# zinit ice silent; zinit snippet OMZP::kubectl
# zinit ice silent; zinit snippet OMZP::kubectx
zinit ice silent; zinit snippet OMZP::command-not-found

# --- History ---
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
# setopt appendhistory sharehistory
# setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
setopt extended_history inc_append_history
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups sharehistory

# --- Completion styling ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- Aliases ---
# ls
# alias ls='lsd -1 --icon=always --group-directories-first'
alias ls='lsd -la --blocks permission,date,size,name --icon=always --group-dirs first --date "+%d/%m/%Y %H:%M"'
alias ll='lsd -la --blocks permission,date,size,name --header --icon=always --group-dirs first --date "+%d/%m/%Y %H:%M"'
alias lt='lsd --tree -a -L 2 --icon=always'

# clear, remove folder/file, move directory
alias cls='clear'
alias ..='cd ..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmf='rm -rf'
alias rmdir='rmdir -v'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# --- fzf integration ---
eval "$(fzf --zsh)"

# Set up fzf key bindings and fuzzy complettion
source <(fzf --zsh)

# --- Troubleshooting (optional) ---
# If you ever see “maximum nested function level reached”, temporarily raise:
# export FUNCNEST=1000

# ------------ Yazi Setup (alias and jump to the path when exit yazi) --------------
export EDITOR="code"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# --- PNPM (https://pnpm.io/installation) ---
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.encore/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --- GIT ALIAS ---
alias git-pop-all='while git stash list | grep .; do git stash pop; done'

# --- OPENVPN3 ALIAS ---
alias vpn-import='openvpn3 config-import --config'
alias vpn-list='openvpn3 profile-list'
