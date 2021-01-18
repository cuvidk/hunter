install() {(
    set -e
    git clone "https://github.com/vortexau/dnsvalidator.git" src-dnsvalidator
    cd src-dnsvalidator
    mkdir -p "${PATH_DNSVALIDATOR}"
    python3 setup.py install --record "${PATH_DNSVALIDATOR}/uninstall.txt"

)}

post_install() {(
    set -e
    rm -rf src-dnsvalidator
    "${MAKE_SCRIPT_DIR}/make_config.sh" install dnsvalidator "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install dnsvalidator "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    [ -e "${PATH_DNSVALIDATOR}/uninstall.txt" ] &&
        cat "${PATH_DNSVALIDATOR}/uninstall.txt" | xargs -I{} rm -rf {}
    rm -rf "${PATH_DNSVALIDATOR}"
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall dnsvalidator "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall dnsvalidator "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
