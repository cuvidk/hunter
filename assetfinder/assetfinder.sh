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
    mkdir -p "${PATH_ASSETFINDER}"

    export GO111MODULE=on
    go get -u github.com/tomnomnom/assetfinder

    ln -s "${GOPATH}/bin/assetfinder" "${PATH_ASSETFINDER}/assetfinder"
    ln -s "${PATH_ASSETFINDER}/assetfinder" /usr/bin/assetfinder
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/assetfinder
    rm -rf "${PATH_ASSETFINDER}"
    rm -rf "${GOPATH}/bin/assetfinder"
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
            perform_task install 'installing assetfinder'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling assetfinder'
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
