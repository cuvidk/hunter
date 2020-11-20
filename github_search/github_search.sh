#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

install() {
    git clone "https://github.com/gwen001/github-search.git" "${PATH_GITHUB_SEARCH}"
}

uninstall() {
    rm -rf "${PATH_GITHUB_SEARCH}"
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing github-search'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling github-search'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
