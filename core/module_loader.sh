#!/bin/bash
export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

function list_modules() {
    log_info "Available Modules:"
    for m in "${PROJ_ROOT}"/modules/*; do
        if [ -f "$m/meta.json" ]; then
            name=$(grep '"name"' "$m/meta.json" | cut -d'"' -f4)
            desc=$(grep '"description"' "$m/meta.json" | cut -d'"' -f4)
            ver=$(grep '"version"' "$m/meta.json" | cut -d'"' -f4)
            echo -e " - \033[1;32m${name} v${ver}\033[0m: ${desc}"
        fi
    done
}

list_modules
