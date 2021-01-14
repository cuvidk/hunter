
#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

uninstall_package() {
    local package_name=$1
    pacman -Rs --noconfirm "${package_name}"
}

uninstall_custom_package() {
    local package_name=$1
    "${SCRIPT_DIR}/make.sh" uninstall "${package_name}" ${VERBOSE}
}

uninstall_packages() {
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
                           httprobe
                           massdns
                           metabigor
                           shosubgo
                           subdomainizer
                           subfinder
                           subover
                           subscraper
                           seclists
                           kalilists'

    for package in ${packages}; do
        perform_task_arg uninstall_package "${package}"
    done

    for package in ${custom_packages}; do
        perform_task_arg uninstall_custom_package "${package}"
    done
}

main() {
    setup_verbosity "${@}"

    uninstall_packages

    check_for_errors
}

main "${@}"

