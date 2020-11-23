#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

install() {(
    set -e
    local version="2.4.5"
    mkdir -p "${SCRIPT_DIR}/subfinder"
    cd "${SCRIPT_DIR}/subfinder"
    wget "https://github.com/projectdiscovery/subfinder/releases/download/v${version}/subfinder_${version}_linux_amd64.tar.gz"
    tar -xzvf "subfinder_${version}_linux_amd64.tar.gz"
    mkdir -p "${PATH_SUBFINDER}"
    mv subfinder "${PATH_SUBFINDER}"
    ln -s "${PATH_SUBFINDER}/subfinder" /usr/bin/subfinder
    cd -
    rm -rf "${SCRIPT_DIR}/subfinder"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subfinder
    rm -rf "${PATH_SUBFINDER}"
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing subfinder'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling subfinder'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
