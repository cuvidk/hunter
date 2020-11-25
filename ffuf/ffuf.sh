export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get "github.com/ffuf/ffuf"
    mkdir -p "${PATH_FFUF}"
    ln -s "${GOPATH}/bin/ffuf" "${PATH_FFUF}/ffuf"
    ln -s "${PATH_FFUF}/ffuf" /usr/bin/ffuf
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/ffuf
    rm -rf "${PATH_FFUF}"
    rm -rf "${GOPATH}/bin/ffuf"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
