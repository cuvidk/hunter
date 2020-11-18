#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/paths.sh"
. "${SCRIPT_DIR}/config-files/paths.sh"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

usage() {
    print_msg "Usage: ${0} <username>"
}

fix_owner() {
    chown -R "${USER}":"${USER}" "${PATH_GOLANG}"
    chown -R "${USER}":"${USER}" "${PATH_WORDLISTS}"
    chown -R "${USER}":"${USER}" "${PATH_AMASS}"
    chown -R "${USER}":"${USER}" "${PATH_AMASS_CONFIG}"
    chown -R "${USER}":"${USER}" "${PATH_METABIGOR}"
}

main() {
    setup_verbosity "${@}"

    [ -z "${1}" ] && usage && exit 1
    USER="${1}"

    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${USER}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && usage && exit 2

    PATH_AMASS_CONFIG="$(echo "${PATH_AMASS_CONFIG}" | sed "s|HOME|${HOME}|")"

    perform_task fix_owner "setting ${USER} as owner of config files"

    check_for_errors
}

main "${@}"
