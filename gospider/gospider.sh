export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    go get -u github.com/jaeles-project/gospider
    mkdir -p "${PATH_GOSPIDER}"
    ln -s "${GOPATH}/bin/gospider" "${PATH_GOSPIDER}/gospider"
    ln -s "${PATH_GOSPIDER}/gospider" /usr/bin/gospider
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/gospider
    rm -rf "${PATH_GOSPIDER}"
    rm -rf "${GOPATH}/bin/gospider"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" uninstall ${VERBOSE}
}
