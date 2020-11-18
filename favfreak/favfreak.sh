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
    git clone "https://github.com/devanshbatham/FavFreak" "${SCRIPT_DIR}/FavFreak"
    mkdir -p "${PATH_FAVFREAK}"
    pip install -r "${SCRIPT_DIR}/FavFreak/requirements.txt"
    cp "${SCRIPT_DIR}/FavFreak/favfreak.py" "${PATH_FAVFREAK}"
    chmod +x "${PATH_FAVFREAK}/favfreak.py"
    ln -s "${PATH_FAVFREAK}/favfreak.py" /usr/bin/favfreak
    rm -rf "${SCRIPT_DIR}/FavFreak"
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/favfreak
    rm -rf "${PATH_FAVFREAK}"
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
            perform_task pre_install 'preinstall favfreak'
            perform_task install 'installing favfreak'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling favfreak'
            perform_task post_uninstall 'postuninstall favfreak'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
