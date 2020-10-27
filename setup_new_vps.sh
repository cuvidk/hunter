#!/bin/sh

set -e

usage() {
    echo "Usage: ${0} <vps_ip>"
}

exec_on_vps() {
    ssh rancher@"${VPS_IP}" ${@}
}

main() {
    VPS_IP=${VPS_IP:-${1}}
    if [ -z "${VPS_IP}" ]; then
        usage
        exit 1
    fi

    exec_on_vps sudo mkdir -p "${TERMINFO}"
    scp -r "${TERMINFO}" rancher@"${VPS_IP}":/home/rancher/terminfo
    exec_on_vps sudo cp -R /home/rancher/terminfo/x "${TERMINFO}"
    exec_on_vps rm -rf /home/rancher/terminfo

    echo "export TERMINFO=${TERMINFO}" >./terminfo.sh
    scp ./terminfo.sh rancher@"${VPS_IP}":/home/rancher
    rm ./terminfo.sh
    exec_on_vps sudo mv /home/rancher/terminfo.sh /etc/profile.d/
}

main "${@}"
