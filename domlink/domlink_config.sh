#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../common/config_common.sh"

WHOXY_API_KEY=${WHOXY_API_KEY:-WHOXY_API_KEY}

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_DOMLINK_CONFIG})"
    sed "s|WHOXY_API_KEY|${WHOXY_API_KEY}|g" "${SCRIPT_DIR}/config/domLink.cfg" >"${PATH_DOMLINK_CONFIG}"
)}

uninstall() {
    rm -rf "${PATH_DOMLINK_CONFIG}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

main() { 
    setup_verbosity "${@}"
    parse_cmd "${@}"

    PATH_DOMLINK_CONFIG=$(echo ${PATH_DOMLINK_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing domlink config for user ${USER}"

    check_for_errors
}

main "${@}"
