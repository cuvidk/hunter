#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/nsonaniya2010/SubDomainizer.git" "${SCRIPT_DIR}/SubDomainizer"
}

install() {(
    set -e
    pip install -r "${SCRIPT_DIR}/SubDomainizer/requirements.txt"
    mkdir "${PATH_SUBDOMAINIZER}"
    cp "${SCRIPT_DIR}/SubDomainizer/SubDomainizer.py" "${PATH_SUBDOMAINIZER}"
    chmod +x "${PATH_SUBDOMAINIZER}/SubDomainizer.py"
    ln -s "${PATH_SUBDOMAINIZER}/SubDomainizer.py" /usr/bin/subdomainizer
    exit 0
)}

post_install() {
    rm -rf "${SCRIPT_DIR}/SubDomainizer"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/subdomainizer
    rm -rf "${PATH_SUBDOMAINIZER}"
    exit 0
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install 'preinstall subdomainizer'
            perform_task install 'installing subdomainizer'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling subdomainizer'
            perform_task post_uninstall 'postuninstall subdomainizer'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
