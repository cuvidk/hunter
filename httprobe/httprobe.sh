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
    mkdir -p "${PATH_HTTPROBE}"

    export GO111MODULE=on
    go get -u github.com/tomnomnom/httprobe

    ln -s "${GOPATH}/bin/httprobe" "${PATH_HTTPROBE}/httprobe"
    ln -s "${PATH_HTTPROBE}/httprobe" /usr/bin/httprobe
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/httprobe
    rm -rf "${PATH_HTTPROBE}"
    rm -rf "${GOPATH}/bin/httprobe"
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
            perform_task install 'installing httprobe'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling httprobe'
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
