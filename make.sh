#!/bin/sh

MAKE_SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${MAKE_SCRIPT_DIR}/config-files/shell-utils/util.sh"
. "${MAKE_SCRIPT_DIR}/config-files/paths.sh"
. "${MAKE_SCRIPT_DIR}/paths.sh"

usage() {
    print_msg "Usage: ${0} <install|uninstall> <pkg> [--verbose]"
}

exit_with_msg() {
    print_msg "${1}\n"
    usage
    exit ${2}
}

main() {
    setup_verbosity "${@}"

    local action="${1}"
    local pkg="${2}"

    [ -z "${pkg}" ] && exit_with_msg "Missing pkg param" 1
    [ ! -f "${pkg}/${pkg}.sh" ] && exit_with_msg "Unknown pkg ${pkg}" 2

    . "${pkg}/${pkg}.sh"

    [ -z "$(type install | grep "function")" ] && exit_with_msg "Missing install func" 3
    [ -z "$(type uninstall | grep "function")" ] && exit_with_msg "Missing uninstall func" 4

    if [ "${action}" = "install" ]; then
        [ -n "$(type pre_install | grep "function")" ] && perform_task pre_install
        perform_task install "Installing ${pkg}"
        [ -n "$(type post_install | grep "function")" ] && perform_task post_install
    elif [ "${action}" = "uninstall" ]; then
        [ -n "$(type pre_uninstall | grep "function")" ] && perform_task pre_uninstall
        perform_task uninstall "Uninstalling ${pkg}"
        [ -n "$(type post_uninstall | grep "function")" ] && perform_task post_uninstall
    else
        exit_with_msg "Unknown action ${action}" 5
    fi

    check_for_errors
}

main "${@}"
