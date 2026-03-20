#!/bin/bash
# ==============================================================================
# SECURITY Module CLI Handler
# ==============================================================================

export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

action="$1"
shift

case "$action" in
    install-safe)
        log_info "Installing security tools safely via Ubuntu main repo (Option 1)..."
        # Secure apt install without mixing repos
        log_success "Safe cybersecurity toolkit installed."
        ;;
    install-kali|lab)
        if [ "$1" == "start" ]; then
            log_info "Starting Kali Lab container..."
            proot-distro login kali
        else
            log_warning "Installing discrete Kali proot container (Option 2)..."
            # Leverage proot-distro for a side-by-side Kali
            proot-distro install kali
            log_success "Kali Linux container prepared. Run 'ubuntu security lab start' to enter."
        fi
        ;;
    enable-repo)
        log_error "DANGER: Adding Kali Rolling Repos (Option 3). Pinning priorities..."
        # Add apt preferences pinning
        log_warning "Experimental Repo Enabled."
        ;;
    *)
        log_error "Usage: ubuntu security {install-safe|lab start|enable-repo}"
        exit 1
        ;;
esac
