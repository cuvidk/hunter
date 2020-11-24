pre_install() {
    "${MAKE_SCRIPT_DIR}/make.sh" install masscan ${VERBOSE}
    git clone "https://github.com/rastating/dnmasscan.git" "${MAKE_SCRIPT_DIR}/Dnmasscan"
}

install() {(
    set -e
    mkdir -p "${PATH_DNMASSCAN}"
    cp "${MAKE_SCRIPT_DIR}/Dnmasscan/dnmasscan" "${PATH_DNMASSCAN}"
    ln -s "${PATH_DNMASSCAN}/dnmasscan" /usr/bin/dnmasscan
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/Dnmasscan"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/dnmasscan
    rm -rf "${PATH_DNMASSCAN}"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/make.sh" uninstall masscan ${VERBOSE}
}
