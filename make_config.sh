#!/bin/sh

MAKE_CONFIG_SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${MAKE_CONFIG_SCRIPT_DIR}/config-files/shell-utils/util.sh"
. "${MAKE_CONFIG_SCRIPT_DIR}/config-files/paths.sh"
. "${MAKE_CONFIG_SCRIPT_DIR}/paths.sh"

perform_replacements() {
    PATH_WORDLISTS=$(echo ${PATH_WORDLISTS} | sed "s|HOME|${HOME}|")
    PATH_AMASS_WORDLISTS=$(echo ${PATH_AMASS_WORDLISTS} | sed "s|HOME|${HOME}|")
    PATH_BRUTESPRAY_WORDLISTS=$(echo ${PATH_BRUTESPRAY_WORDLISTS} | sed "s|HOME|${HOME}|")
    PATH_AMASS=$(echo ${PATH_AMASS} | sed "s|HOME|${HOME}|")
    PATH_METABIGOR=$(echo ${PATH_METABIGOR} | sed "s|HOME|${HOME}|")
    PATH_GOSPIDER=$(echo ${PATH_GOSPIDER} | sed "s|HOME|${HOME}|")
    PATH_HAKRAWLER=$(echo ${PATH_HAKRAWLER} | sed "s|HOME|${HOME}|")
    PATH_GITHUB_SUBDOMAINS=$(echo ${PATH_GITHUB_SUBDOMAINS} | sed "s|HOME|${HOME}|")
    PATH_ASSETFINDER=$(echo ${PATH_ASSETFINDER} | sed "s|HOME|${HOME}|")
    PATH_HTTPROBE=$(echo ${PATH_HTTPROBE} | sed "s|HOME|${HOME}|")
    PATH_SUBOVER=$(echo ${PATH_SUBOVER} | sed "s|HOME|${HOME}|")
    PATH_FFUF=$(echo ${PATH_FFUF} | sed "s|HOME|${HOME}|")
    PATH_ASNLOOKUP=$(echo ${PATH_ASNLOOKUP} | sed "s|HOME|${HOME}|")
    PATH_DOMLINK=$(echo ${PATH_DOMLINK} | sed "s|HOME|${HOME}|")
    PATH_SUBDOMAINIZER=$(echo ${PATH_SUBDOMAINIZER} | sed "s|HOME|${HOME}|")
    PATH_SUBFINDER=$(echo ${PATH_SUBFINDER} | sed "s|HOME|${HOME}|")
    PATH_MASSDNS=$(echo ${PATH_MASSDNS} | sed "s|HOME|${HOME}|")
    PATH_MASSCAN=$(echo ${PATH_MASSCAN} | sed "s|HOME|${HOME}|")
    PATH_DNMASSCAN=$(echo ${PATH_DNMASSCAN} | sed "s|HOME|${HOME}|")
    PATH_BRUTESPRAY=$(echo ${PATH_BRUTESPRAY} | sed "s|HOME|${HOME}|")
    PATH_GETRELATIONSHIP=$(echo ${PATH_GETRELATIONSHIP} | sed "s|HOME|${HOME}|")
    PATH_FAVFREAK=$(echo ${PATH_FAVFREAK} | sed "s|HOME|${HOME}|")
    PATH_SHOSUBGO=$(echo ${PATH_SHOSUBGO} | sed "s|HOME|${HOME}|")
    PATH_SUBSCRAPER=$(echo ${PATH_SUBSCRAPER} | sed "s|HOME|${HOME}|")
    PATH_EYEWITNESS=$(echo ${PATH_EYEWITNESS} | sed "s|HOME|${HOME}|")
    PATH_GITHUB_SEARCH=$(echo ${PATH_GITHUB_SEARCH} | sed "s|HOME|${HOME}|")
    PATH_AMASS_CONFIG=$(echo ${PATH_AMASS_CONFIG} | sed "s|HOME|${HOME}|")
    PATH_DOMLINK_CONFIG=$(echo ${PATH_DOMLINK_CONFIG} | sed "s|HOME|${HOME}|")
    PATH_SHOSUBGO_CONFIG=$(echo ${PATH_SHOSUBGO_CONFIG} | sed "s|HOME|${HOME}|")
    PATH_SUBSCRAPER_CONFIG=$(echo ${PATH_SUBSCRAPER_CONFIG} | sed "s|HOME|${HOME}|")
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> <pkg> <username> [--verbose]"
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
    local user="${3}"

    [ -z "${pkg}" ] && exit_with_msg "Missing pkg param" 1
    [ ! -f "${MAKE_CONFIG_SCRIPT_DIR}/${pkg}/${pkg}_config.sh" ] && exit_with_msg "Missing ${pkg}_config.sh" 2

    [ -z "${user}" ] && exit_with_msg "Missing user param" 3
    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${user}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && exit_with_msg "Unable to find home dir for ${user}" 4

    perform_replacements

    # source config script after replacements
    . "${MAKE_CONFIG_SCRIPT_DIR}/${pkg}/${pkg}_config.sh"

    [ -z "$(type install | grep "function")" ] && exit_with_msg "Missing install func" 5
    [ -z "$(type uninstall | grep "function")" ] && exit_with_msg "Missing uninstall func" 6

    if [ "${action}" = "install" ]; then
        [ -n "$(type pre_install | grep "function")" ] && perform_task pre_install
        perform_task install "Installing ${pkg} config for user ${user}"
        [ -n "$(type post_install | grep "function")" ] && perform_task post_install
    elif [ "${action}" = "uninstall" ]; then
        [ -n "$(type pre_uninstall | grep "function")" ] && perform_task pre_uninstall
        perform_task uninstall "Uninstalling ${pkg} config ${user}"
        [ -n "$(type post_uninstall | grep "function")" ] && perform_task post_uninstall
    else
        exit_with_msg "Unknown action ${action}" 5
    fi

    check_for_errors
}

main "${@}"
