#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../common/config_common.sh"

export CENSYS_API_KEY="${CENSYS_API_KEY:-CENSYS_API_KEY}"
export CENSYS_SECRET="${CENSYS_SECRET:-CENSYS_SECRET}"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SUBSCRAPER_CONFIG})"
    if [ -f "${PATH_SUBSCRAPER_CONFIG}" ]; then
        sed -i "s|PATH_SUBSCRAPER|${PATH_SUBSCRAPER}|g" "${PATH_SUBSCRAPER_CONFIG}"
        sed -i "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" "${PATH_SUBSCRAPER_CONFIG}"
        sed -i "s|CENSYS_SECRET|${CENSYS_SECRET}|g" "${PATH_SUBSCRAPER_CONFIG}"
    else
        sed "s|PATH_SUBSCRAPER|${PATH_SUBSCRAPER}|g" "${SCRIPT_DIR}/config/subscraper.sh" |
        sed "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" |
        sed "s|CENSYS_SECRET|${CENSYS_SECRET}|g" >"${PATH_SUBSCRAPER_CONFIG}"
    fi
    exit 0
)}

uninstall() {
    rm -rf "${PATH_SUBSCRAPER_CONFIG}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

main() { 
    setup_verbosity "${@}"
    parse_cmd "${@}"

    PATH_SUBSCRAPER_CONFIG=$(echo ${PATH_SUBSCRAPER_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing subscraper config for user ${USER}"

    check_for_errors
}

main "${@}"
