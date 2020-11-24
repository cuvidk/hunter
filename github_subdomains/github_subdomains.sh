export GOPATH="${GOPATH:-${PATH_GOLANG}}"

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" install ${VERBOSE}
}

install() {(
    set -e
    go get -u github.com/gwen001/github-subdomains
    mkdir -p "${PATH_GITHUB_SUBDOMAINS}"
    ln -s "${GOPATH}/bin/github-subdomains" "${PATH_GITHUB_SUBDOMAINS}/github-subdomains"
    ln -s "${PATH_GITHUB_SUBDOMAINS}/github-subdomains" /usr/bin/github-subdomains
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/github-subdomains
    rm -rf "${PATH_GITHUB_SUBDOMAINS}"
    rm -rf "${GOPATH}/bin/github-subdomains"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/config-files/go/go.sh" uninstall ${VERBOSE}
}
