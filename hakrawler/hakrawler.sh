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
    go get -u github.com/hakluke/hakrawler
    mkdir -p "${PATH_HAKRAWLER}"
    ln -s "${GOPATH}/bin/hakrawler" "${PATH_HAKRAWLER}/hakrawler"
    ln -s "${PATH_HAKRAWLER}/hakrawler" /usr/bin/hakrawler
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/hakrawler
    rm -rf "${PATH_HAKRAWLER}"
    rm -rf "${GOPATH}/bin/hakrawler"
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
            perform_task install 'installing hakrawler'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling hakrawler'
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
