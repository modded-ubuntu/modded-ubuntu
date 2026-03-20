#!/bin/bash
# ==============================================================================
# Utility: Config Manager
# ==============================================================================

function set_config() {
    local key="\$1"
    local value="\$2"
    
    if [ ! -f "\$CONFIG_FILE" ]; then
        touch "\$CONFIG_FILE"
    fi
    
    if grep -q "^\${key}=" "\$CONFIG_FILE"; then
        sed -i "s|^\${key}=.*|\${key}=\"\${value}\"|" "\$CONFIG_FILE"
    else
        echo "\${key}=\"\${value}\"" >> "\$CONFIG_FILE"
    fi
}

function get_config() {
    local key="\$1"
    local default="\$2"
    
    if [ -f "\$CONFIG_FILE" ]; then
        local value=$(grep "^\${key}=" "\$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"')
        if [ ! -z "\$value" ]; then
            echo "\$value"
            return
        fi
    fi
    echo "\$default"
}
