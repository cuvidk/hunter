#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${SCRIPT_DIR}/../config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e

    export GO111MODULE=on
    go get -v github.com/OWASP/Amass/v3/...

    mkdir -p "${PATH_AMASS}"
    echo '#!/bin/sh' >"${PATH_AMASS}/amass.sh"
    echo "${GOPATH}/bin/amass" '${@}' "-dir ${PATH_AMASS}" >>"${PATH_AMASS}/amass.sh"
    chmod +x "${PATH_AMASS}/amass.sh"
    ln -s "${PATH_AMASS}/amass.sh" /usr/bin/amass

    git clone "https://github.com/OWASP/Amass" "${SCRIPT_DIR}/Amass"
    mkdir -p "${PATH_AMASS_WORDLISTS}"
    cp -r "${SCRIPT_DIR}/Amass/examples/wordlists/" "${PATH_AMASS_WORDLISTS}"
    rm -rf "${SCRIPT_DIR}/Amass"
    exit 0
)}

post_install() {(
    set -e
    "${SCRIPT_DIR}/amass_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/amass_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/amass
    rm -rf "${PATH_AMASS}"
    rm -rf "${PATH_AMASS_WORDLISTS}"
    rm -rf "${GOPATH}/bin/amass"
    exit 0
)}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/amass_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/amass_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
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
            perform_task install 'installing amass'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling amass'
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
