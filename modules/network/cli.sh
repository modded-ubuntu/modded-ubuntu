#!/bin/bash
# ==============================================================================
# NETWORK Module CLI Handler
# ==============================================================================

export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

action="$1"
shift

case "$action" in
    ssh-start)
        log_info "Starting SSH Server..."
        pkg install openssh -y >/dev/null 2>&1
        sshd
        log_success "SSH Server started on port 8022. Use 'whoami' to get user and 'passwd' to set password."
        ;;
    ssh-stop)
        log_info "Stopping SSH Server..."
        pkill sshd
        log_success "SSH Server stopped."
        ;;
    tunnel)
        log_info "Starting Cloudflared SSH Tunnel..."
        pkg install cloudflared -y >/dev/null 2>&1
        cloudflared tunnel --url ssh://localhost:8022 &
        log_success "Cloudflared Tunnel started in background."
        ;;
    *)
        log_error "Usage: ubuntu network {ssh-start|ssh-stop|tunnel}"
        exit 1
        ;;
esac
