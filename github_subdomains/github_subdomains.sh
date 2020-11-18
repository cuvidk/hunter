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
    go get -u github.com/gwen001/github-subdomains
    mkdir -p "${PATH_GITHUB_SUBDOMAINS}"
    ln -s "${GOPATH}/bin/github-subdomains" "${PATH_GITHUB_SUBDOMAINS}/github-subdomains"
    ln -s "${PATH_GITHUB_SUBDOMAINS}/github-subdomains" /usr/bin/github-subdomains
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/github-subdomains
    rm -rf "${PATH_GITHUB_SUBDOMAINS}"
    rm -rf "${GOPATH}/bin/github-subdomains"
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
            perform_task install 'installing github-subdomains'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling github-subdomains'
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
