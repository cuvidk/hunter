export GOPATH="${GOPATH:-${PATH_GOLANG}}"
GITHUB_API_KEY=${GITHUB_API_KEY:-GITHUB_API_KEY}

pre_install() {
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    go get -u github.com/gwen001/github-subdomains
    mkdir -p "${PATH_GITHUB_SUBDOMAINS}"
    echo '#!/bin/sh' >"${PATH_GITHUB_SUBDOMAINS}/github-subdomains.sh"
    echo "${GOPATH}/bin/github-subdomains" '${@}' "-t ${GITHUB_API_KEY}" >"${PATH_GITHUB_SUBDOMAINS}/github-subdomains.sh"
    ln -s "${PATH_GITHUB_SUBDOMAINS}/github-subdomains.sh" /usr/bin/github-subdomains
    chmod +x "${PATH_GITHUB_SUBDOMAINS}/github-subdomains.sh"
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
    "${MAKE_SCRIPT_DIR}/config-files/make.sh" uninstall go ${VERBOSE}
}
