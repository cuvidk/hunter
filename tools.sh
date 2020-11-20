#!/bin/sh

###################### INSTALL ######################

install_github_search() {
    git clone "https://github.com/gwen001/github-search.git" "${GITHUB_SEARCH_PATH}"
    chown -R "${g_user}:${g_user}" "${GITHUB_SEARCH_PATH}"
}

install_nmap() {
    pacman -S --noconfirm nmap
}

install_medusa() {
    pacman -S --noconfirm medusa
}

install_sqlmap() {
    pacman -S --noconfirm sqlmap
}

fix_wordlists_owner() {
    chown -R "${g_user}:${g_user}" "${WORDLISTS_PATH}"
}

install_all() {
    install_github_search
    install_nmap
    install_medusa
    install_sqlmap
    fix_wordlists_owner
}

###################### UNINSTALL ######################

remove_github_search() {
    rm -rf "${GITHUB_SEARCH_PATH}"
}

remove_nmap() {
    pacman -Rs --noconfirm nmap
}

remove_medusa() {
    pacman -Rs --noconfirm medusa
}

remove_sqlmap() {
    pacman -Rs --noconfirm sqlmap
}

remove_wordlists() {
    rm -rf "${WORDLISTS_PATH}"
}

remove_all() {
    remove_github_search
    remove_nmap
    remove_medusa
    remove_sqlmap
    remove_wordlists
}

#######################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/config-files/install_paths.sh"

export GOPATH="${PATH_GOLANG}"
GO_PACKAGE_PATH="${PATH_GOLANG}"

GITHUB_SEARCH_PATH='/opt/github-search'

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
