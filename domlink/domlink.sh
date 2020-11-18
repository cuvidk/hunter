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
    git clone "https://github.com/vysecurity/DomLink.git" "${SCRIPT_DIR}/DomLink"
    pip install -r "${SCRIPT_DIR}/DomLink/requirements.txt"
    mkdir -p "${PATH_DOMLINK}"
    cp "${SCRIPT_DIR}/DomLink/domLink.py" "${PATH_DOMLINK}"
    chmod +x "${PATH_DOMLINK}/domLink.py"
    ln -s "${PATH_DOMLINK}/domLink.py" /usr/bin/domlink
    rm -rf "${SCRIPT_DIR}/DomLink"
)}

post_install() {(
    set -e
    "${SCRIPT_DIR}/domlink_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/domlink_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/domlink
    rm -rf "${PATH_DOMLINK}"
)}

post_uninstall() {
    "${SCRIPT_DIR}/domlink_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/domlink_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    pacman -Rs --noconfirm python-pip
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install 'preinstall domlink'
            perform_task install 'installing domlink'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling domlink'
            perform_task post_uninstall
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
