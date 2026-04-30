#!/bin/bash
export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

action="$1"
name="$2"

case "$action" in
    create)
        if [ -z "$name" ]; then name=$(date "+%Y%m%d_%H%M%S"); fi
        log_info "Creating snapshot: $name..."
        mkdir -p "${PROJ_ROOT}/snapshots"
        tar -czf "${PROJ_ROOT}/snapshots/${name}.tar.gz" -C /data/data/com.termux/files/usr/var/lib/proot-distro/installed ubuntu
        log_success "Snapshot $name created."
        ;;
    list)
        log_info "Available snapshots:"
        ls -lh "${PROJ_ROOT}/snapshots" | awk '{print $9, $5}'
        ;;
    restore)
        if [ -z "$name" ]; then log_error "Specify snapshot name"; exit 1; fi
        log_warning "Restoring snapshot $name..."
        rm -rf /data/data/com.termux/files/usr/var/lib/proot-distro/installed/ubuntu/*
        tar -xzf "${PROJ_ROOT}/snapshots/${name}.tar.gz" -C /data/data/com.termux/files/usr/var/lib/proot-distro/installed
        log_success "Snapshot restored successfully."
        ;;
    *)
        log_error "Usage: ubuntu snapshot {create|list|restore} [name]"
        exit 1
        ;;
esac
