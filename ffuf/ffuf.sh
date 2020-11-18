#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${SCRIPT_DIR}/../config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    go get "github.com/ffuf/ffuf"
    mkdir -p "${PATH_FFUF}"
    ln -s "${GOPATH}/bin/ffuf" "${PATH_FFUF}/ffuf"
    ln -s "${PATH_FFUF}/ffuf" /usr/bin/ffuf
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/ffuf
    rm -rf "${PATH_FFUF}"
    rm -rf "${GOPATH}/bin/ffuf"
)}

post_uninstall() {
    "${SCRIPT_DIR}/../config-files/go/go.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing ffuf'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling ffuf'
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
