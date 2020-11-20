#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {(
    set -e
    pacman -S --noconfirm python-pip
    pip install ipparser
    git clone "https://github.com/m8r0wn/subscraper" "${SCRIPT_DIR}/subscraper"
)}

install() {(
    set -e
    cd "${SCRIPT_DIR}/subscraper"
    python3 setup.py install
    mkdir -p "${PATH_SUBSCRAPER}"
    mv /usr/bin/subscraper "${PATH_SUBSCRAPER}/subscraper"
    cp "${SCRIPT_DIR}/config/subscraper.sh" "${PATH_SUBSCRAPER}"
    chmod +x "${PATH_SUBSCRAPER}/subscraper.sh"
    ln -s "${PATH_SUBSCRAPER}/subscraper.sh" /usr/bin/subscraper
)}

post_install() {(
    set -e
    rm -rf "${SCRIPT_DIR}/subscraper"
    "${SCRIPT_DIR}/subscraper_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/subscraper_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subscraper
    rm -rf "${PATH_SUBSCRAPER}"
)}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/subscraper_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/subscraper_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    pacman -Rs --noconfirm python-pip
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing subscraper'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling subscraper'
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
