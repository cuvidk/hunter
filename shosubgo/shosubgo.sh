#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

export GOPATH="${GOPATH:-${PATH_GOLANG}}"
export SHODAN_API_KEY="${SHODAN_API_KEY:-'SHODAN_API_KEY'}"

pre_install() {
    "${SCRIPT_DIR}/../config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    git clone "https://github.com/incogbyte/shosubgo" "${PATH_SHOSUBGO}"
    echo '#!/bin/sh' >"${PATH_SHOSUBGO}/shosubgo.sh"
    echo "go run ${PATH_SHOSUBGO}/main.go -s ${SHODAN_API_KEY}" '${@}' >>"${PATH_SHOSUBGO}/shosubgo.sh"
    chmod +x "${PATH_SHOSUBGO}/shosubgo.sh"
    ln -s "${PATH_SHOSUBGO}/shosubgo.sh" /usr/bin/shosubgo
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/shosubgo
    rm -rf "${PATH_SHOSUBGO}"
)}

post_uninstall() {
    "${SCRIPT_DIR}/../config-files/go/go.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing shosubgo'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling shosubgo'
            perform_task post_uninstall
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
