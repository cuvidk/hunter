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
    go get -u github.com/j3ssie/metabigor
    mkdir -p "${PATH_METABIGOR}"
    ln -s "${GOPATH}/bin/metabigor" "${PATH_METABIGOR}/metabigor"
    ln -s "${PATH_METABIGOR}/metabigor" /usr/bin/metabigor
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/metabigor
    rm -rf "${PATH_METABIGOR}"
    rm -rf "${GOPATH}/bin/metabigor"
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
            perform_task install 'installing metabigor'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling metabigor'
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
