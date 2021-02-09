export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get github.com/haccer/subjack
    mkdir -p "${PATH_SUBJACK}"
    ln -s "${GOPATH}/bin/subjack" /usr/bin/subjack
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subjack
    rm -rf "${GOPATH}/bin/subjack"
    exit 0
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
    exit 0
)}
