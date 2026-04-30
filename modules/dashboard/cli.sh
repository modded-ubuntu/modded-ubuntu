#!/bin/bash
export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

action="$1"
shift

case "$action" in
    start)
        log_info "Starting Web Dashboard..."
        python3 "${PROJ_ROOT}/modules/dashboard/app.py" &
        echo $! > "${PROJ_ROOT}/modules/dashboard/pid"
        log_success "Dashboard started on http://127.0.0.1:8080"
        ;;
    stop)
        log_info "Stopping Web Dashboard..."
        if [ -f "${PROJ_ROOT}/modules/dashboard/pid" ]; then
            kill $(cat "${PROJ_ROOT}/modules/dashboard/pid") 2>/dev/null
            rm "${PROJ_ROOT}/modules/dashboard/pid"
            log_success "Dashboard stopped."
        else
            log_warning "Dashboard is not running."
        fi
        ;;
    *)
        log_error "Usage: ubuntu dashboard {start|stop}"
        exit 1
        ;;
esac
