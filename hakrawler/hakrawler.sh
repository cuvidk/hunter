export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get -u github.com/hakluke/hakrawler
    mkdir -p "${PATH_HAKRAWLER}"
    ln -s "${GOPATH}/bin/hakrawler" "${PATH_HAKRAWLER}/hakrawler"
    ln -s "${PATH_HAKRAWLER}/hakrawler" /usr/bin/hakrawler
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/hakrawler
    rm -rf "${PATH_HAKRAWLER}"
    rm -rf "${GOPATH}/bin/hakrawler"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
