#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

install_package() {
    local package_name=$1
    pacman -S --noconfirm --needed "${package_name}"
}

install_custom_package() {
    local package_name=$1
    "${SCRIPT_DIR}/${package_name}/${package_name}.sh" install ${VERBOSE}
}

install_packages() {
    local packages='nmap
                    medusa
                    sqlmap'

    local custom_packages='amass
                           asnlookup
                           assetfinder
                           brutespray
                           dnmasscan
                           domlink
                           eyewitness
                           favfreak
                           ffuf
                           getrelationship
                           github_search
                           github_subdomains
                           gospider
                           hakrawler
                           hooks
                           httprobe
                           masscan
                           massdns
                           metabigor
                           shosubgo
                           subdomainizer
                           subfinder
                           subover
                           subscraper'

    for package in ${packages}; do
        perform_task_arg install_package "${package}"
    done

    for package in ${custom_packages}; do
        perform_task_arg install_custom_package "${package}"
    done
}

main() {
    setup_verbosity "${@}"

    install_packages

    check_for_errors
}

main "${@}"

