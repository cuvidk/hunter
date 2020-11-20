#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {
    "${WORKING_DIR}/../masscan/masscan.sh" install ${VERBOSE}
    git clone "https://github.com/rastating/dnmasscan.git" "${SCRIPT_DIR}/dnmasscan"
}

install() {(
    set -e
    mkdir -p "${PATH_DNMASSCAN}"
    cp "${SCRIPT_DIR}/dnmasscan/dnmasscan" "${PATH_DNMASSCAN}"
    ln -s "${PATH_DNMASSCAN}/dnmasscan" /usr/bin/dnmasscan
)}

post_install() {
    rm -rf "${SCRIPT_DIR}/dnmasscan"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/dnmasscan
    rm -rf "${PATH_DNMASSCAN}"
)}

post_uninstall() {
    "${WORKING_DIR}/../masscan/masscan.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing dnmasscan'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling dnmasscan'
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
