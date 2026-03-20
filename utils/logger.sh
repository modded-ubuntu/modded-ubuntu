#!/bin/bash
# ==============================================================================
# Utility: Logger
# ==============================================================================

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_RESET='\033[0m'

function log_write() {
    local type="\$1"
    local message="\$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] [${type}] ${message}" >> "\${LOG_FILE}"
}

function log_info() {
    echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} \$1"
    log_write "INFO" "\$1"
}

function log_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} \$1"
    log_write "SUCCESS" "\$1"
}

function log_warning() {
    echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} \$1"
    log_write "WARNING" "\$1"
}

function log_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} \$1"
    log_write "ERROR" "\$1"
}
