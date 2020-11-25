export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    mkdir -p "${PATH_HTTPROBE}"

    export GO111MODULE=on
    go get -u github.com/tomnomnom/httprobe

    ln -s "${GOPATH}/bin/httprobe" "${PATH_HTTPROBE}/httprobe"
    ln -s "${PATH_HTTPROBE}/httprobe" /usr/bin/httprobe
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/httprobe
    rm -rf "${PATH_HTTPROBE}"
    rm -rf "${GOPATH}/bin/httprobe"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
