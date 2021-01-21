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
    chown -R "${USER}":"${USER}" "${PATH_LISTS}"
    chown -R "${USER}":"${USER}" "${PATH_AMASS}"
    chown -R "${USER}":"${USER}" "${PATH_AMASS_CONFIG}"
    chown -R "${USER}":"${USER}" "${PATH_METABIGOR}"
    chown -R "${USER}":"${USER}" "${PATH_GOSPIDER}"
    chown -R "${USER}":"${USER}" "${PATH_HAKRAWLER}"
    chown -R "${USER}":"${USER}" "${PATH_GITHUB_SUBDOMAINS}"
    chown -R "${USER}":"${USER}" "${PATH_ASSETFINDER}"
    chown -R "${USER}":"${USER}" "${PATH_HTTPROBE}"
    chown -R "${USER}":"${USER}" "${PATH_SUBOVER}"
    chown -R "${USER}":"${USER}" "${PATH_FFUF}"
    chown -R "${USER}":"${USER}" "${PATH_ASNLOOKUP}"
    chown -R "${USER}":"${USER}" "${PATH_DOMLINK}"
    chown -R "${USER}":"${USER}" "${PATH_SUBDOMAINIZER}"
    chown -R "${USER}":"${USER}" "${PATH_SUBFINDER}"
    chown -R "${USER}":"${USER}" "${PATH_MASSDNS}"
    chown -R "${USER}":"${USER}" "${PATH_MASSCAN}"
    chown -R "${USER}":"${USER}" "${PATH_DNMASSCAN}"
    chown -R "${USER}":"${USER}" "${PATH_BRUTESPRAY}"
    chown -R "${USER}":"${USER}" "${PATH_GETRELATIONSHIP}"
    chown -R "${USER}":"${USER}" "${PATH_FAVFREAK}"
    #chown -R "${USER}":"${USER}" "${PATH_SHOSUBGO}"
    chown -R "${USER}":"${USER}" "${PATH_SUBSCRAPER}"
    #chown -R "${USER}":"${USER}" "${PATH_EYEWITNESS}"
    chown -R "${USER}":"${USER}" "${PATH_GITHUB_SEARCH}"
    chown -R "${USER}":"${USER}" "${PATH_DNSVALIDATOR}"
    chown -R "${USER}":"${USER}" "${PATH_LINKFINDER}"
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
