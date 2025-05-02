# Path: scripts/lib/distro-utils.sh

#!/usr/bin/env bash
# Provides functions for detecting the Linux distro and installing packages using the appropriate package manager.

set -euo pipefail

# Logging functions
log_info()    { echo -e "[INFO]    $*" >&2; }
log_warn()    { echo -e "[WARNING] $*" >&2; }
log_error()   { echo -e "[ERROR]   $*" >&2; }
log_fatal()   { echo -e "[FATAL]   $*" >&2; exit 1; }

# Globals set during detection
DISTRO_ID=""
DISTRO_LIKE=""
PKG_MANAGER=""
DETECTED=false

# Detect Linux distribution and package manager
detect_distro() {
    if [[ "$DETECTED" == true ]]; then return 0; fi

    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DISTRO_ID="${ID,,}"
        DISTRO_LIKE="${ID_LIKE,,:-}"
    else
        log_fatal "Cannot detect Linux distribution: /etc/os-release missing."
    fi

    case "$DISTRO_ID" in
        ubuntu|debian)
            PKG_MANAGER="apt-get"
            ;;
        arch|manjaro)
            PKG_MANAGER="pacman"
            ;;
        fedora)
            PKG_MANAGER="dnf"
            ;;
        centos|rhel)
            PKG_MANAGER="yum"
            ;;
        alpine)
            PKG_MANAGER="apk"
            ;;
        *)
            # Fallback to ID_LIKE if ID is unrecognized
            case "$DISTRO_LIKE" in
                debian)
                    PKG_MANAGER="apt-get"
                    ;;
                rhel|fedora)
                    PKG_MANAGER="yum"
                    ;;
                arch)
                    PKG_MANAGER="pacman"
                    ;;
                *)
                    log_fatal "Unsupported or unrecognized distribution: $DISTRO_ID"
                    ;;
            esac
            ;;
    esac

    log_info "Detected distro: $DISTRO_ID"
    log_info "Using package manager: $PKG_MANAGER"
    DETECTED=true
}

# Install a package with the appropriate package manager
install_package() {
    local pkg="$1"

    if [[ -z "$pkg" ]]; then
        log_error "No package name provided to install_package"
        return 1
    fi

    detect_distro

    case "$PKG_MANAGER" in
        apt-get)
            sudo apt-get update -qq
            sudo apt-get install -y "$pkg" || log_fatal "Failed to install $pkg via apt-get"
            ;;
        yum)
            sudo yum install -y "$pkg" || log_fatal "Failed to install $pkg via yum"
            ;;
        dnf)
            sudo dnf install -y "$pkg" || log_fatal "Failed to install $pkg via dnf"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$pkg" || log_fatal "Failed to install $pkg via pacman"
            ;;
        apk)
            sudo apk add --no-cache "$pkg" || log_fatal "Failed to install $pkg via apk"
            ;;
        *)
            log_fatal "No supported package manager found for $DISTRO_ID"
            ;;
    esac

    log_info "Successfully installed $pkg"
}

# Check for a dependency and install it if missing
check_and_install_dep() {
    local dep="$1"
    if ! command -v "$dep" >/dev/null 2>&1; then
        log_warn "Dependency '$dep' is missing. Attempting to install..."
        install_package "$dep"
    else
        log_info "Dependency '$dep' is already installed."
    fi
}

# Install multiple dependencies
check_and_install_deps() {
    local deps=("$@")
    for dep in "${deps[@]}"; do
        check_and_install_dep "$dep"
    done
}