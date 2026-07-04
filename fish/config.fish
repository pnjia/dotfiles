if status is-interactive
    set -x BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
    fish_add_path $HOME/.cargo/bin
    set -x EDITOR nvim
    if type -q lsd
        alias l='lsd -l'
        alias la='lsd -a'
        alias lla='lsd -la'
        alias lt='lsd --tree'
        alias ls='lsd'
    end

    # Ensure tmux uses UTF-8
    alias tmux="tmux -u"
end

# fnm
set PATH ~/.local/share/fnm $PATH
fnm env --use-on-cd | source

set -gx PATH $HOME/.nvm/versions/node/v24.16.0/bin $PATH

# Added by Antigravity CLI installer
set -gx PATH "/home/panjiangka1/.local/bin" $PATH

# Change to home directory on startup
# cd ~

fish_add_path /home/panjiangka1/.spicetify
set -gx KIMCHI_API_KEY castai_v1_4bfc57cf7ac596a232af3a5cde0390f8aa251cd448237c05bf6bd9968896286d_d6fe90d3
alias waveterm="/snap/waveterm/current/waveterm --no-sandbox"
set -gx HOMEBREW_PREFIX $HOME/.brew
fish_add_path $HOME/.brew/bin
fish_add_path $HOME/.brew/sbin
fish_add_path $HOME/.local/share/gem/ruby/3.3.0/bin
eval ($HOME/.brew/bin/brew shellenv)

# Menambahkan untuk zoxide
zoxide init fish | source
