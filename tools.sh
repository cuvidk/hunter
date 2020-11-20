#!/bin/sh

###################### INSTALL ######################

install_nmap() {
    pacman -S --noconfirm nmap
}

install_medusa() {
    pacman -S --noconfirm medusa
}

install_sqlmap() {
    pacman -S --noconfirm sqlmap
}

install_all() {
    install_nmap
    install_medusa
    install_sqlmap
}

###################### UNINSTALL ######################

remove_nmap() {
    pacman -Rs --noconfirm nmap
}

remove_medusa() {
    pacman -Rs --noconfirm medusa
}

remove_sqlmap() {
    pacman -Rs --noconfirm sqlmap
}

remove_all() {
    remove_nmap
    remove_medusa
    remove_sqlmap
}

#######################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/config-files/install_paths.sh"

export GOPATH="${PATH_GOLANG}"
GO_PACKAGE_PATH="${PATH_GOLANG}"

usage() {
    echo "Usage: ${0} <install|remove> [--user <user_owning_tools>]"
}

if [ $(id -u) -ne 0 ]; then
    echo "Run this as root."
    exit 1
fi

case "${1}" in
    "install")
        operation=install_all
        shift
        ;;
    "remove")
        operation=remove_all
        shift
        ;;
    *)
        usage
        exit 2
        ;;
esac

g_user="root"
if [ $# -gt 0 ]; then
    case "${1}" in
        "--user")
            g_user="${2}"
            ;;
        *)
            usage
            exit 3
            ;;
    esac
fi

if [ "$(cat /etc/passwd | grep "${g_user}" | cut -d ':' -f1)" != "${g_user}" ]; then
    echo "Unknown user ${g_user}"
    exit 4
fi

${operation}
