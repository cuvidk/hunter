#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../common/config_common.sh"

SHODAN_API_KEY=${SHODAN_API_KEY:-'SHODAN_API_KEY'}

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SHOSUBGO_CONFIG})"
    if [ -f "${PATH_SHOSUBGO_CONFIG}" ]; then
        sed -i "s|PATH_SHOSUBGO|${PATH_SHOSUBGO}|g" "${PATH_SHOSUBGO_CONFIG}"
        sed -i "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" "${PATH_SHOSUBGO_CONFIG}"
    else
        sed "s|PATH_SHOSUBGO|${PATH_SHOSUBGO}|g" "${SCRIPT_DIR}/config/shosubgo.sh" |
        sed "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" >"${PATH_SHOSUBGO_CONFIG}"
    fi
    exit 0
)}

uninstall() {
    rm -rf "${PATH_SHOSUBGO_CONFIG}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

main() { 
    setup_verbosity "${@}"
    parse_cmd "${@}"

    PATH_SHOSUBGO_CONFIG=$(echo ${PATH_SHOSUBGO_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing shosubgo config for user ${USER}"

    check_for_errors
}

main "${@}"
