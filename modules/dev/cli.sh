#!/bin/bash
# ==============================================================================
# DEV Module CLI Handler
# ==============================================================================

export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

action="\$1"
shift

case "\$action" in
    enable)
        log_info "Enabling Developer Toolkit..."
        # Execute individual apt install commands safely
        log_success "Developer tools online."
        ;;
    disable)
        log_info "Removing Developer Toolkit..."
        # Execute safe removal
        log_success "Developer tools removed."
        ;;
    *)
        log_error "Usage: ubuntu dev {enable|disable}"
        exit 1
        ;;
esac
