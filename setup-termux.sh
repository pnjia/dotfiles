#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export PATH="$PREFIX/bin:$PATH"

echo "======================================="
echo "  Termux Dotfiles Installer"
echo "======================================="

# ── 1. Install packages ──────────────────────────────────────────────
echo "[1/8] Menginstall packages..."
pkg update -y
pkg install -y \
    fish \
    tmux \
    neovim \
    git \
    curl \
    lsd \
    fd \
    zoxide \
    fzf \
    ripgrep \
    nodejs \
    which

# ── 2. Fish shell ────────────────────────────────────────────────────
echo "[2/8] Setup fish..."
mkdir -p ~/.config/fish/completions
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/functions

cat > ~/.config/fish/config.fish << 'FISH_CONFIG'
if status is-interactive
    set -x EDITOR nvim
    if type -q lsd
        alias l='lsd -l'
        alias la='lsd -a'
        alias lla='lsd -la'
        alias lt='lsd --tree'
        alias ls='lsd'
    end

    alias tmux="tmux -u"
end

# fnm (uncomment if you use fnm)
# set PATH ~/.local/share/fnm $PATH
# fnm env --use-on-cd | source

# zoxide
zoxide init fish | source

# fd
alias fd='fd'

# Rust/Cargo (uncomment if you install Rust)
# fish_add_path $HOME/.cargo/bin
# source "$HOME/.cargo/env.fish"
FISH_CONFIG

# Copy other fish configs
cp -f "$DOTFILES_DIR/fish/fish_variables" ~/.config/fish/fish_variables 2>/dev/null || true
cp -rf "$DOTFILES_DIR/fish/functions/"* ~/.config/fish/functions/ 2>/dev/null || true
cp -rf "$DOTFILES_DIR/fish/completions/"* ~/.config/fish/completions/ 2>/dev/null || true

# conf.d (adapted for Termux — no OMF or rustup by default)
cp -f "$DOTFILES_DIR/fish/conf.d/omf.fish" ~/.config/fish/conf.d/omf.fish 2>/dev/null || true
cp -f "$DOTFILES_DIR/fish/conf.d/rustup.fish" ~/.config/fish/conf.d/rustup.fish 2>/dev/null || true

# ── 3. Tmux ──────────────────────────────────────────────────────────
echo "[3/8] Setup tmux..."
mkdir -p ~/.config/tmux/plugins

cat > ~/.tmux.conf << 'TMUX_CONF'
set -g escape-time 0

unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

set-option -g default-shell fish

set -g mouse on
set -g history-limit 50000

set -g default-terminal "tmux-256color"
set -as terminal-features ",xterm-256color:RGB"
set -as terminal-features ",tmux-256color:RGB"

set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM

setw -g mode-keys vi

set -g base-index 1
setw -g pane-base-index 1

bind -n M-p previous-window
bind -n M-n next-window
bind -n M-c new-window -c "#{pane_current_path}"
bind -n M-- split-window -v -c "#{pane_current_path}"
bind -n M-= split-window -h -c "#{pane_current_path}"
bind -n M-x confirm-before -p "kill-window #W? (y/n)" kill-window
bind -n M-\\ confirm-before -p "kill-pane #P? (y/n)" kill-pane

bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R
bind -n M-\[ switch-client -p
bind -n M-\] switch-client -n
bind -n M-s choose-tree -s
bind -n S-Space next-layout

bind -n M-r source-file ~/.tmux.conf \; display-message "Config reloaded"

set -g set-clipboard on
set -g allow-passthrough on

# Termux clipboard
if-shell "command -v termux-clipboard-set" {
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "termux-clipboard-set"
    bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "termux-clipboard-set"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "termux-clipboard-set"
    bind-key p run-shell "termux-clipboard-get | tmux load-buffer -" \; paste-buffer
}

# Fallback: termux-clipboard not available
if-shell "! command -v termux-clipboard-set" {
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "cat | tmux load-buffer -"
    bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "cat | tmux load-buffer -"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "cat | tmux load-buffer -"
}

set -g pane-border-lines single
set -g pane-border-style 'fg=#313244'
set -g pane-active-border-style 'fg=#cba6f7'

set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_window_text " #W"
set -g @catppuccin_window_current_text " #W"

run ~/.config/tmux/plugins/catppuccin/catppuccin.tmux

set -g status-position bottom
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -agF status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"

# Disable extra status-format lines (tmux 3.3+)
set -g status-format[1] ""
set -g status-format[2] ""

run ~/.config/tmux/plugins/tmux-cpu/cpu.tmux

set -g automatic-rename off
setw -g allow-rename off
TMUX_CONF

# ── 4. Fix SSL lib mismatch & Tmux plugins ───────────────────────────
echo "[4/8] Sync SSL libraries & install tmux plugins..."
# Fix "SSL_set_quic_tls_transport_params" linker error — out-of-sync openssl/libngtcp2
pkg reinstall -y git curl openssl libngtcp2 ca-certificates 2>/dev/null || true

install_plugin() {
    local name="$1"
    local url="$2"
    local dir="$HOME/.config/tmux/plugins/$name"
    if [ -d "$dir" ]; then return 0; fi
    echo "  -> Install $name..."
    if git clone --depth 1 "$url" "$dir" 2>/dev/null; then return 0; fi
    echo "  -> git-remote-https gagal, pakai curl+tar fallback..."
    local tmpdir="$PREFIX/tmp/plugin-$$-$name"
    mkdir -p "$tmpdir"
    curl -fsSL "${url%.git}/archive/HEAD.tar.gz" | tar -xz -C "$tmpdir" --strip-components=1
    rm -rf "$dir" 2>/dev/null || true
    mv "$tmpdir" "$dir"
}

install_plugin "tpm"         "https://github.com/tmux-plugins/tpm"
install_plugin "catppuccin"  "https://github.com/catppuccin/tmux.git"
install_plugin "tmux-cpu"    "https://github.com/tmux-plugins/tmux-cpu"

# ── 5. Neovim (LazyVim) ─────────────────────────────────────────────
echo "[5/8] Setup neovim..."
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    echo "  -> Backup existing nvim ke ~/.config/nvim.bak"
    mv ~/.config/nvim ~/.config/nvim.bak
fi

if [ -L ~/.config/nvim ]; then
    rm ~/.config/nvim
fi

ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# ── 6. Tmuxinator (optional) ────────────────────────────────────────
echo "[6/8] Setup tmuxinator (optional)..."
if command -v ruby &>/dev/null; then
    if ! command -v tmuxinator &>/dev/null; then
        gem install tmuxinator --no-document 2>/dev/null || true
    fi
    mkdir -p ~/.config/tmuxinator
    cp -f "$DOTFILES_DIR/tmuxinator/"*.yml ~/.config/tmuxinator/ 2>/dev/null || true
fi

# ── 7. Install JetBrains Mono Nerd Font ──────────────────────────────
echo "[7/8] Install JetBrains Mono Nerd Font..."
FONT_FILE="$HOME/.termux/font.ttf"
mkdir -p "$HOME/.termux"
if [ -f "$FONT_FILE" ]; then
    echo "  -> Font sudah ada, backup ke font.ttf.bak"
    cp "$FONT_FILE" "$FONT_FILE.bak"
fi

curl -fLo "$FONT_FILE" \
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFont-Regular.ttf"

if [ -f "$FONT_FILE" ]; then
    termux-reload-settings 2>/dev/null || true
    echo "  -> Font JetBrains Mono Nerd Font terinstall"
fi

# ── 8. Set fish as default shell ────────────────────────────────────
echo "[8/8] Set fish sebagai default shell..."
FISH_PATH="$(command -v fish)"
if [ -n "$FISH_PATH" ]; then
    mkdir -p ~/.termux
    echo "$FISH_PATH" > ~/.termux/shell
fi

echo ""
echo "======================================="
echo "  Selesai!"
echo "======================================="
echo ""
echo "Langkah selanjutnya:"
echo "  1. Restart Termux (atau buka session baru)"
echo "  2. Jalankan 'fish' jika belum otomatis"
echo "  3. Buka nvim → nvim otomatis install plugin (tunggu selesai)"
echo "  4. Untuk tmux, jalankan 'tmux'"
echo ""
echo "Catatan:"
echo "  - fish_variables menyimpan warna prompt dari PC — prompt tetap dipakai"
echo "  - Oh My Fish (omf) perlu diinstall manual: curl -L https://get.oh-my.fish | fish"
echo "  - Rust/Cargo: pkg install rust"
echo "  - fnm: pkg install fnm"
echo "  - Jika prompt error 'hostname', install: pkg install net-tools"
