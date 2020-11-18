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
    go get "github.com/Ice3man543/SubOver"
    mkdir -p "${PATH_SUBOVER}"
    ln -s "${GOPATH}/bin/SubOver" "${PATH_SUBOVER}/subover"
    ln -s "${PATH_SUBOVER}/subover" /usr/bin/subover
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subover
    rm -rf "${PATH_SUBOVER}"
    rm -rf "${GOPATH}/bin/SubOver"
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
            perform_task install 'installing subover'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling subover'
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
