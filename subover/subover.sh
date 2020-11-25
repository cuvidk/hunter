export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get "github.com/Ice3man543/SubOver"
    mkdir -p "${PATH_SUBOVER}"
    ln -s "${GOPATH}/bin/SubOver" "${PATH_SUBOVER}/subover"
    ln -s "${PATH_SUBOVER}/subover" /usr/bin/subover
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subover
    rm -rf "${PATH_SUBOVER}"
    rm -rf "${GOPATH}/bin/SubOver"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
