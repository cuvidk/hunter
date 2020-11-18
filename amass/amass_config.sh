!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"

ALIENVAULT_API_KEY=${ALIENVAULT_API_KEY:-'ALIENVAULT_API_KEY'}
BINARYEDGE_API_KEY=${BINARYEDGE_API_KEY:-'BINARYEDGE_API_KEY'}
CENSYS_API_KEY=${CENSYS_API_KEY:-'CENSYS_API_KEY'}
CENSYS_SECRET=${CENSYS_SECRET:-'CENSYS_SECRET'}
CLOUDFARE_API_KEY=${CLOUDFARE_API_KEY:-'CLOUDFARE_API_KEY'}
GITHUB_API_KEY=${GITHUB_API_KEY:-'GITHUB_API_KEY'}
NETWORKSDB_API_KEY=${NETWORKSDB_API_KEY:-'NETWORKSDB_API_KEY'}
PASSIVETOTAL_API_KEY=${PASSIVETOTAL_API_KEY:-'PASSIVETOTAL_API_KEY'}
PASSIVETOTAL_USERNAME=${PASSIVETOTAL_USERNAME:-'PASSIVETOTAL_USERNAME'}
RECONDEV_API_KEY=${RECONDEV_API_KEY:-'RECONDEV_API_KEY'}
SECURITYTRAILS_API_KEY=${SECURITYTRAILS_API_KEY:-'SECURITYTRAILS_API_KEY'}
SHODAN_API_KEY=${SHODAN_API_KEY:-'SHODAN_API_KEY'}
URLSCAN_API_KEY=${URLSCAN_API_KEY:-'URLSCAN_API_KEY'}
VIRUSTOTAL_API_KEY=${VIRUSTOTAL_API_KEY:-'VIRUSTOTAL_API_KEY'}
WHOISXMLAPI_API_KEY=${WHOISXMLAPI_API_KEY:-'WHOISXMLAPI_API_KEY'}
ZOOMEYE_USERNAME=${ZOOMEYE_USERNAME:-'ZOOMEYE_USERNAME'}
ZOOMEYE_PASSWORD=${ZOOMEYE_PASSWORD:-'ZOOMEYE_PASSWORD'}

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_AMASS_CONFIG})"
    sed "s|ALIENVAULT_API_KEY|${ALIENVAULT_API_KEY}|g" "${SCRIPT_DIR}/config/config.ini" |
    sed "s|BINARYEDGE_API_KEY|${BINARYEDGE_API_KEY}|g" |
    sed "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" |
    sed "s|CENSYS_SECRET|${CENSYS_SECRET}|g" |
    sed "s|CLOUDFARE_API_KEY|${CLOUDFARE_API_KEY}|g" |
    sed "s|GITHUB_API_KEY|${GITHUB_API_KEY}|g" |
    sed "s|NETWORKSDB_API_KEY|${NETWORKSDB_API_KEY}|g" |
    sed "s|PASSIVETOTAL_API_KEY|${PASSIVETOTAL_API_KEY}|g" |
    sed "s|PASSIVETOTAL_USERNAME|${PASSIVETOTAL_USERNAME}|g" |
    sed "s|RECONDEV_API_KEY|${RECONDEV_API_KEY}|g" |
    sed "s|SECURITYTRAILS_API_KEY|${SECURITYTRAILS_API_KEY}|g" |
    sed "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" |
    sed "s|URLSCAN_API_KEY|${URLSCAN_API_KEY}|g" |
    sed "s|VIRUSTOTAL_API_KEY|${VIRUSTOTAL_API_KEY}|g" |
    sed "s|WHOISXMLAPI_API_KEY|${WHOISXMLAPI_API_KEY}|g" |
    sed "s|ZOOMEYE_USERNAME|${ZOOMEYE_USERNAME}|g" |
    sed "s|ZOOMEYE_PASSWORD|${ZOOMEYE_PASSWORD}|g" |
    sed "s|PATH_AMASS_WORDLISTS|${PATH_AMASS_WORDLISTS}|g" >"${PATH_AMASS_CONFIG}"
)}

uninstall() {
    rm -rf "${PATH_AMASS_CONFIG}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            action=install
            shift
            ;;
        "uninstall")
            action=uninstall
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    USER=
    while [ $# -gt 0 ]; do
        case "${1}" in
            "--for-user")
                USER="${2}"
                break
                ;;
            *)
                shift
                ;;
        esac
    done

    [ -z "${USER}" ] && usage && exit 2
    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${USER}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && usage && exit 3

    PATH_AMASS_CONFIG=$(echo ${PATH_AMASS_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing amass config for user ${USER}"

    check_for_errors
}

main "${@}"
