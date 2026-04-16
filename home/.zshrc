
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes) zinit light-mode for \
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

THEME_NAME="geometry-zsh/geometry"
# THEME_NAME="jackharrisonsherlock/common"
# THEME_NAME="egorlem/ultima.zsh-theme"

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zinit load mafredri/zsh-async
zinit load zsh-users/zsh-history-substring-search
zinit load zsh-users/zsh-completions
zinit load chrissicool/zsh-256color
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice lucid depth"1" blockf
zinit load yuki-yano/zeno.zsh

zinit load $THEME_NAME

GEOMETRY_STATUS_SYMBOL="󰆧"
GEOMETRY_STATUS_SYMBOL_ERROR="󱐝"

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt extended_history
setopt hist_expire_dups_first

autoload -Uz compinit; compinit
autoload -Uz colors; colors

zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

setopt auto_param_slash
setopt auto_param_keys
setopt mark_dirs
setopt auto_menu
setopt correct
setopt interactive_comments
setopt magic_equal_subst
setopt complete_in_word
setopt print_eight_bit
setopt auto_cd
setopt no_beep

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Functions
# fzf history
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^w' fzf-select-history

# fzf cdr
function fzf-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --reverse)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-cdr
setopt noflowcontrol
bindkey '^q' fzf-cdr

function _fzf_cd_ghq() {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local root="$(ghq root)"
    local repo="$(ghq list | fzf --preview="ls -AF --color=always ${root}/{1}")"
    local dir="${root}/${repo}"
    [ -n "${dir}" ] && cd "${dir}"
    zle accept-line
    zle reset-prompt
}
zle -N _fzf_cd_ghq
bindkey "^z" _fzf_cd_ghq

function _fzf_cd_prj() {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local root="${HOME}/projects"
    local prj="$(ls ${root} | fzf)"
    local dir="${root}/${prj}"
    [ -n "${dir}" ] && cd "${dir}"
    zle accept-line
    zle reset-prompt
}
zle -N _fzf_cd_prj
bindkey "^p" _fzf_cd_prj

function mkcd() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# Aliases
if [[ $(command -v eza) ]]; then
  alias e='eza --icons --git'
  alias l=e
  alias ls=e
  alias ea='eza -a --icons --git'
  alias la=ea
  alias ee='eza -aahl --icons --git'
  alias ll=ee
  alias et='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
  alias l='clear && ls'
fi

if [[ $(command -v tmux) ]]; then
  if [[ ! -e "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
fi

if command -v lazygit &> /dev/null; then
  declare -x LG_CONFIG_FILE=~/.config/lazygit/config.yml
  export LG_CONFIG_FILE

  function lg(){
    lazygit "$@"
  }
fi

eval "$($HOME/.local/bin/mise activate zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

alias nv="$HOME/bin/nvim-11/bin/nvim"
alias acmd='act --container-architecture linux/amd64'

# eval "$(zellij setup --generate-auto-start zsh)"

export EDITOR='nvim'

export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="$HOME/bin:$PATH"

source $HOME/.zeno_zsh
