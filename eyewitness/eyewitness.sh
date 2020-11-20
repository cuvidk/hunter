#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

install() {(
    set -e
    git clone 'https://github.com/cuvidk/EyeWitness.git' "${PATH_EYEWITNESS}"
    cd "${PATH_EYEWITNESS}"
    git checkout cuvidk-fork
    sh "${PATH_EYEWITNESS}/Python/setup/setup.sh"
    ln -s "${PATH_EYEWITNESS}/Python/EyeWitness.py" /usr/bin/eyewitness
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/eyewitness
    rm -rf "${PATH_EYEWITNESS}"
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing eyewitness'
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling eyewitness'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
