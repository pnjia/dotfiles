set -g fish_greeting

alias ls "eza --icons"
alias ll "eza -l --icons"
alias la "eza -la --icons"
alias lt "eza --tree --icons"
alias cat "bat"
alias vim "nvim"
alias vi "nvim"
alias grep "rg"

set -x EDITOR nvim
set -x VISUAL nvim
set -x BROWSER brave

starship init fish | source
zoxide init fish | source

set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/go/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
