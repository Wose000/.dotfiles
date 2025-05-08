# To customize prompt.
export PATH="$HOME/.local/bin/:$PATH"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.json)"

export EDITOR=nvim
export PATH="$HOME/bin:$PATH"
export PATH="/bin:$PATH"
export PATH="/usr/lib/node_modules:$PATH"

# Add the .NET SDK to the system paths so we can use the `dotnet` tool.
# .NET SDK Configuration
export DOTNET_ROOT="/usr/share/dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Disable analytics
export DOTNET_ROLL_FORWARD_TO_PRERELEASE=1

export PATH="$DOTNET_ROOT:$PATH"
export PATH="$DOTNET_ROOT/sdk:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
# Run this if you ever run into errors while doing a `dotnet restore`
alias nugetclean="dotnet nuget locals --clear all"

# Java environment
JAVA_HOME="/usr/lib/jvm/java-21-openjdk"  
export PATH="$JAVA_HOME/bin:$PATH"

# PLUGINGS
autoload -Uz compinit && compinit
fpath=($HOME/.config/zsh/zsh-completions/src/ $fpath)
source $HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Functions
source $HOME/bin/fun.sh
bindkey -v
# navigating prompt history
bindkey '^o' clear-screen
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# Tmux sessions finder
bindkey -s '^f' "ssel^M"


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
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# ALIASES
alias ls='eza' # Colored ls output
alias lt='eza --tree --icons=always' # Tree ls output
alias l='eza -lah --icons=always --group-directories-first --smart-group' # Colored ls output
alias stowd='stow --dotfiles'
alias gs='git status'
# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

alias onedrive='rclone --vfs-cache-mode writes mount "onedrive": ~/mnt/onedrive/'

bindkey '^y' fzf-completion
