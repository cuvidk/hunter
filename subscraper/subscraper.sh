#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../config-files/shell-utils/util.sh"
. "${SCRIPT_DIR}/../config-files/paths.sh"
. "${SCRIPT_DIR}/../paths.sh"

export CENSYS_API_KEY="${CENSYS_API_KEY:-'CENSYS_API_KEY'}"
export CENSYS_SECRET="${CENSYS_SECRET:-'CENSYS_SECRET'}"

pre_install() {(
    set -e
    pacman -S --noconfirm python-pip
    pip install ipparser
    git clone "https://github.com/m8r0wn/subscraper" "${SCRIPT_DIR}/subscraper"
)}

install() {(
    set -e
    cd "${SCRIPT_DIR}/subscraper"
    python3 setup.py install
    mkdir -p "${PATH_SUBSCRAPER}"
    mv /usr/bin/subscraper "${PATH_SUBSCRAPER}/subscraper"
    echo '#!/bin/sh' >"${PATH_SUBSCRAPER}/subscraper.sh"
    echo "${PATH_SUBSCRAPER}/subscraper --censys-api ${CENSYS_API_KEY} --censys-secret ${CENSYS_SECRET}" '${@}' >>"${PATH_SUBSCRAPER}/subscraper.sh"
    chmod +x "${PATH_SUBSCRAPER}/subscraper.sh"
    ln -s "${PATH_SUBSCRAPER}/subscraper.sh" /usr/bin/subscraper
)}

post_install() {(
    set -e
    rm -rf "${SCRIPT_DIR}/subscraper"
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subscraper
    rm -rf "${PATH_SUBSCRAPER}"
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing subscraper'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling subscraper'
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
