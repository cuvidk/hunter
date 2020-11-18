#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {(
    set -e
    pacman -S --noconfirm --needed medusa
    pacman -S --noconfirm --needed python-pip
)}

install() {(
    set -e
    git clone "https://github.com/x90skysn3k/brutespray.git" "${SCRIPT_DIR}/brutespray"
    mkdir -p "${PATH_BRUTESPRAY}"
    pip install -r "${SCRIPT_DIR}/brutespray/requirements.txt"
    cp "${SCRIPT_DIR}/brutespray/brutespray.py" "${PATH_BRUTESPRAY}"
    ln -s "${PATH_BRUTESPRAY}/brutespray.py" /usr/bin/brutespray
    cp -r "${SCRIPT_DIR}/brutespray/wordlist/" "${PATH_BRUTESPRAY_WORDLISTS}"
    rm -rf "${SCRIPT_DIR}/brutespray"
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/brutespray
    rm -rf "${PATH_BRUTESPRAY}"
    rm -rf "${PATH_BRUTESPRAY_WORDLISTS}"
)}

post_uninstall() {(
    set -e
    pacman -Rs --noconfirm medusa
    pacman -Rs --noconfirm python-pip
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install 'preinstall brutespray'
            perform_task install 'installing brutespray'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling brutespray'
            perform_task post_uninstall 'postuninstall brutespray'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
