#!/bin/bash
# ACRO Distro - Premium Redirector (Full Free Update)

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

clear
echo ""
echo -e "${C}╔═══════════════════════════════════════════════════════════════════╗${D}"
echo -e "${C}║${W}           🎉 ACRO PREMIUM IS NOW 100% FREE! 🎉                    ${C}║${D}"
echo -e "${C}╠═══════════════════════════════════════════════════════════════════╣${D}"
echo -e "${C}║${D}                                                                   ${C}║${D}"
echo -e "${C}║${W}  All Premium, Pro+, and Ultimate packages have been merged into   ${C}║${D}"
echo -e "${C}║${W}  the free, open-source repository. You can choose any package     ${C}║${D}"
echo -e "${C}║${W}  and customize your system freely during installation.            ${C}║${D}"
echo -e "${C}║${D}                                                                   ${C}║${D}"
echo -e "${C}║${G}  Redirecting you to setup.sh in 3 seconds...                      ${C}║${D}"
echo -e "${C}║${D}                                                                   ${C}║${D}"
echo -e "${C}╚═══════════════════════════════════════════════════════════════════╝${D}"
echo ""

sleep 3
if [ -f "./setup.sh" ]; then
    bash ./setup.sh
else
    echo -e "${R}Error: setup.sh not found. Cloned repository might be incomplete.${D}"
    exit 1
fi
