export GOPATH="${GOPATH:-${PATH_GOLANG}}"
export SHODAN_API_KEY="${SHODAN_API_KEY:-'SHODAN_API_KEY'}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    git clone "https://github.com/incogbyte/shosubgo" "${PATH_SHOSUBGO}"
    cp "${MAKE_SCRIPT_DIR}/shosubgo/config/shosubgo.sh" "${PATH_SHOSUBGO}"
    chmod +x "${PATH_SHOSUBGO}/shosubgo.sh"
    ln -s "${PATH_SHOSUBGO}/shosubgo.sh" /usr/bin/shosubgo
    exit 0
)}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/shosubgo/shosubgo_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/shosubgo/shosubgo_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
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
    "${MAKE_SCRIPT_DIR}/shosubgo/shosubgo_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/shosubgo/shosubgo_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" uninstall ${VERBOSE}
    exit 0
)}
