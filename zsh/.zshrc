# To customize prompt.
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/myconf.toml)"

export EDITOR=nvim
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
# PLUGINGS
autoload -Uz compinit && compinit
fpath=($HOME/.config/zsh/zsh-completions/src/ $fpath)
source $HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Functions
source $HOME/bin/fun.sh
# vi style bindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s '^f' '$HOME/bin/ssel/ssel\n'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt autocd extendedglob
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# completition styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ALIASES
alias ls='eza' # Colored ls output
alias lt='eza --tree --icons=always' # Tree ls output
alias l='eza -lah --icons=always --group-directories-first --smart-group' # Colored ls output
alias stowd='stow --dotfiles'
alias gs='git status'
# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
