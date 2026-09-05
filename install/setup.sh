# by neroki
# https://github.com/neroki194/niri-dotfiles
#
# Assumes this repo mirrors your home directory layout, e.g.:
#   dotfiles/
#     .config/
#       niri/
#       foot/
#       nvim/
#       fuzzel/
#       fastfetch/
#       dankmaterialshell/
#       starship.toml
#
# Usage:
#   ./setup.sh            # symlink dotfiles (backs up existing files)
#   ./setup.sh --packages # also install listed pacman/AUR packages
#   ./setup.sh --dry-run  # show what would happen, change nothing

set -euo pipefail

# ---- config ---------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Only these .config subdirs/files get linked (edit to add/remove configs)
CONFIG_ITEMS=(
  niri
  foot
  nvim
  fuzzel
  fastfetch
  dankmaterialshell
  starship.toml
)

declare -A EXTRA_LINKS=(
)

PACMAN_PACKAGES=(niri foot neovim fuzzel fastfetch starship)
AUR_PACKAGES=()   

# ---- flags ------------------------------------------------------------

DRY_RUN=false
DO_PACKAGES=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --packages) DO_PACKAGES=true ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^#//'
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

# ---- helpers ------------------------------------------------------------

log()  { printf '\033[1;34m[*]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
run()  { if $DRY_RUN; then echo "  + $*"; else eval "$@"; fi }

require_arch() {
  if ! command -v pacman >/dev/null 2>&1; then
    warn "pacman not found — this script targets Arch Linux, continuing anyway"
  fi
}

# ---- package install ------------------------------------------------------

install_packages() {
  log "Installing pacman packages: ${PACMAN_PACKAGES[*]}"
  run "sudo pacman -S --needed --noconfirm ${PACMAN_PACKAGES[*]}"

  if [ "${#AUR_PACKAGES[@]}" -gt 0 ]; then
    if command -v yay >/dev/null 2>&1; then
      log "Installing AUR packages: ${AUR_PACKAGES[*]}"
      run "yay -S --needed --noconfirm ${AUR_PACKAGES[*]}"
    else
      warn "yay not found — skipping AUR packages: ${AUR_PACKAGES[*]}"
    fi
  fi
}

# ---- linking ------------------------------------------------------------

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local rel="${target#$HOME/}"
    local dest="$BACKUP_DIR/$rel"
    log "Backing up existing $target -> $dest"
    if ! $DRY_RUN; then
      mkdir -p "$(dirname "$dest")"
      mv "$target" "$dest"
    fi
  fi
}

link_one() {
  local src_path="$1"
  local dst_path="$2"

  if [ ! -e "$src_path" ]; then
    warn "Source missing, skipping: $src_path"
    return
  fi

  mkdir -p "$(dirname "$dst_path")" 2>/dev/null || true
  backup_if_exists "$dst_path"

  log "Linking $dst_path -> $src_path"
  run "ln -sfn '$src_path' '$dst_path'"
  ok "${dst_path#$HOME/}"
}

link_dotfiles() {
  for item in "${CONFIG_ITEMS[@]}"; do
    link_one "$DOTFILES_DIR/.config/$item" "$HOME/.config/$item"
  done

  for src in "${!EXTRA_LINKS[@]}"; do
    link_one "$DOTFILES_DIR/$src" "$HOME/${EXTRA_LINKS[$src]}"
  done
}

# ---- main ------------------------------------------------------------

main() {
  require_arch
  $DRY_RUN && warn "Dry run — no changes will be made"

  if $DO_PACKAGES; then
    install_packages
  fi

  link_dotfiles

  ok "Installation is done :3, Backups (if any) saved to $BACKUP_DIR"
}

main
