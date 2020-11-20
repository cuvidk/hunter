!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"

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
)}

uninstall() {
    rm -rf "${PATH_SUBSCRAPER_CONFIG}"
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

    PATH_SUBSCRAPER_CONFIG=$(echo ${PATH_SUBSCRAPER_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing subscraper config for user ${USER}"

    check_for_errors
}

main "${@}"
