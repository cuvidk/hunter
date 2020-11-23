#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {
    git clone 'https://github.com/blechschmidt/massdns.git' "${SCRIPT_DIR}/massdns"
}

install() {(
    set -e
    cd "${SCRIPT_DIR}/massdns"
    make
    mkdir -p "${PATH_MASSDNS}"
    cp "${SCRIPT_DIR}/massdns/bin/massdns" "${PATH_MASSDNS}"
    cp -R "${SCRIPT_DIR}/massdns/lists" "${PATH_MASSDNS}"
    ln -s "${PATH_MASSDNS}/massdns" /usr/bin/massdns
    exit 0
)}

post_install() {
    rm -rf "${SCRIPT_DIR}/massdns"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/massdns
    rm -rf "${PATH_MASSDNS}"
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing massdns'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling massdns'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
