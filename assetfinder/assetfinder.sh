export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    mkdir -p "${PATH_ASSETFINDER}"

    export GO111MODULE=on
    go get -u github.com/tomnomnom/assetfinder

    ln -s "${GOPATH}/bin/assetfinder" "${PATH_ASSETFINDER}/assetfinder"
    ln -s "${PATH_ASSETFINDER}/assetfinder" /usr/bin/assetfinder
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/assetfinder
    rm -rf "${PATH_ASSETFINDER}"
    rm -rf "${GOPATH}/bin/assetfinder"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" uninstall ${VERBOSE}
}
