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
    cp "${SCRIPT_DIR}/config/shosubgo.sh" "${PATH_SHOSUBGO}"
    chmod +x "${PATH_SHOSUBGO}/shosubgo.sh"
    ln -s "${PATH_SHOSUBGO}/shosubgo.sh" /usr/bin/shosubgo
    exit 0
)}

post_install() {(
    set -e
    "${SCRIPT_DIR}/shosubgo_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/shosubgo_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/shosubgo
    rm -rf "${PATH_SHOSUBGO}"
    exit 0
)}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/shosubgo_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/shosubgo_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    "${SCRIPT_DIR}/../config-files/go/go.sh" uninstall ${VERBOSE}
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing shosubgo'
            perform_task post_install
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
