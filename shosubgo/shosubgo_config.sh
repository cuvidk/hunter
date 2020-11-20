!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"

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
)}

uninstall() {
    rm -rf "${PATH_SHOSUBGO_CONFIG}"
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

    PATH_SHOSUBGO_CONFIG=$(echo ${PATH_SHOSUBGO_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing shosubgo config for user ${USER}"

    check_for_errors
}

main "${@}"
