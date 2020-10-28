#!/bin/sh

set -e

usage() {
    echo "Usage: ${0} <vps_ip>"
}

exec_on_vps() {
    ssh root@"${VPS_IP}" ${@}
}

main() {
    VPS_IP=${VPS_IP:-${1}}
    if [ -z "${VPS_IP}" ]; then
        usage
        exit 1
    fi

    local terminfo_path='/usr/share/terminfo/x/'
    scp "${terminfo_path}/xterm-kitty" root@"${VPS_IP}":"${terminfo_path}/xterm-kitty"
    exec_on_vps reboot
}

main "${@}"
