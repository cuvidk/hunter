#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {
    pacman -S --noconfirm --needed python-pip
}

install() {(
    set -e
    git clone "https://github.com/yassineaboukir/Asnlookup" "${SCRIPT_DIR}/Asnlookup"
    pip install -r "${SCRIPT_DIR}/Asnlookup/requirements.txt"
    mkdir -p "${PATH_ASNLOOKUP}"
    cp "${SCRIPT_DIR}/Asnlookup/asnlookup.py" "${PATH_ASNLOOKUP}"
    chmod +x "${PATH_ASNLOOKUP}/asnlookup.py"
    ln -s "${PATH_ASNLOOKUP}/asnlookup.py" /usr/bin/asnlookup
    rm -rf "${SCRIPT_DIR}/Asnlookup"
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/asnlookup
    rm -rf "${PATH_ASNLOOKUP}"
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
            perform_task pre_install 'preinstall asnlookup'
            perform_task install 'installing asnlookup'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling asnlookup'
            perform_task post_uninstall 'postuninstall asnlookup'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
