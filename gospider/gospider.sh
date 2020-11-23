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
    go get -u github.com/jaeles-project/gospider
    mkdir -p "${PATH_GOSPIDER}"
    ln -s "${GOPATH}/bin/gospider" "${PATH_GOSPIDER}/gospider"
    ln -s "${PATH_GOSPIDER}/gospider" /usr/bin/gospider
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/gospider
    rm -rf "${PATH_GOSPIDER}"
    rm -rf "${GOPATH}/bin/gospider"
    exit 0
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
            perform_task install 'installing gospider'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling gospider'
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
