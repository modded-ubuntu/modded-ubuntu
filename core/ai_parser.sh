#!/bin/bash
export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

instruction="$1"

log_info "AI Assist processing: '$instruction'"

# Very basic rule-based parsing
if echo "$instruction" | grep -qi "install python"; then
    log_info "Mapping to: ubuntu dev enable"
    bash "${PROJ_ROOT}/modules/dev/cli.sh" enable
elif echo "$instruction" | grep -qi "start gui"; then
    log_info "Mapping to: ubuntu gui start"
    bash "${PROJ_ROOT}/modules/gui/cli.sh" start
elif echo "$instruction" | grep -qi "status"; then
    log_info "Mapping to: ubuntu status"
    bash "${PROJ_ROOT}/core/system_monitor.sh"
else
    log_warning "Command not understood. Please use specific keywords like 'start gui' or 'install python'."
fi
