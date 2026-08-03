#!/bin/bash
set -e

LOG_FILE="/tmp/xtradeb_install.log"
rm -f "$LOG_FILE"

# Function to show current status/log line when interrupted
trap_log() {
    echo -e "\n\n[LOG INTERRUPT] Current running operation:"
    if [ -f "$LOG_FILE" ]; then
        tail -n 3 "$LOG_FILE"
    else
        echo "No log data available yet."
    fi
    echo ""
}

# Catch SIGINT (Ctrl+C) to print log status
trap 'trap_log' SIGINT

# Function to retry a command up to 50 times if it fails (e.g. APT locks)
retry_command() {
    local max_attempts=50
    local attempt=1
    local delay=3

    until "$@"; do
        if [ $attempt -ge $max_attempts ]; then
            echo "Command failed after $max_attempts attempts." >> "$LOG_FILE"
            return 1
        fi
        echo "Attempt $attempt failed (resource locked or network issue). Retrying in ${delay}s..." >> "$LOG_FILE"
        sleep $delay
        ((attempt++))
    done
    return 0
}

# Spinner animation function
run_with_spinner() {
    local msg="$1"
    shift
    local pid

    # Run command in background through the retry function and redirect output to log file
    ( retry_command "$@" ) >> "$LOG_FILE" 2>&1 &
    pid=$!

    local spin='-\|/'
    local i=0

    echo -n "$msg "
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\b${spin:$i:1}"
        sleep 0.1
    done
    
    wait $pid
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        printf "\b[OK]\n"
    else
        printf "\b[FAILED]\n"
        echo "Check $LOG_FILE for details."
        exit 1
    fi
}

echo "=================================================="
echo "    XtraDeb Repo Installer for Modded Ubuntu     "
echo "=================================================="
echo "Log file: $LOG_FILE"
echo ""

# 1. Preparing directories
run_with_spinner "[1/4] Preparing GPG directories..." bash -c '
    mkdir -p /root/.gnupg && \
    chmod 700 /root/.gnupg && \
    mkdir -p /etc/apt/keyrings
'

# 2. Installing dependencies
run_with_spinner "[2/4] Verifying base dependencies..." bash -c '
    apt-get update -qq && \
    apt-get install -y curl gnupg dirmngr
'

# 3. Downloading GPG Key
run_with_spinner "[3/4] Fetching XtraDeb GPG Key..." bash -c '
    curl -sS "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x82BB6851C64F6880" | \
    gpg --dearmor --yes -o /etc/apt/keyrings/xtradeb.gpg
'

# 4. Creating repository source file
run_with_spinner "[4/4] Generating APT source file..." bash -c '
cat << "SOURCES" > /etc/apt/sources.list.d/xtradeb.sources
Types: deb
URIs: https://ppa.launchpadcontent.net/xtradeb/apps/ubuntu
Suites: resolute
Components: main
Signed-By: /etc/apt/keyrings/xtradeb.gpg

Types: deb
URIs: https://ppa.launchpadcontent.net/xtradeb/play/ubuntu
Suites: resolute
Components: main
Signed-By: /etc/apt/keyrings/xtradeb.gpg
SOURCES
'

# Updating APT Package Index
run_with_spinner "Updating APT index..." apt-get update

echo ""
echo "XtraDeb repository setup completed successfully!"
echo ""
echo "=================================================="
echo "Installation Log:"
echo "=================================================="
cat "$LOG_FILE"
echo "=================================================="
