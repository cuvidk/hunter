export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get -u github.com/j3ssie/metabigor
    mkdir -p "${PATH_METABIGOR}"
    ln -s "${GOPATH}/bin/metabigor" "${PATH_METABIGOR}/metabigor"
    ln -s "${PATH_METABIGOR}/metabigor" /usr/bin/metabigor
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/metabigor
    rm -rf "${PATH_METABIGOR}"
    rm -rf "${GOPATH}/bin/metabigor"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
