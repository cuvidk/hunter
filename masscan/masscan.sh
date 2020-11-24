pre_install() {
    git clone 'https://github.com/robertdavidgraham/masscan' "${MAKE_SCRIPT_DIR}/Masscan"
}

install() {(
    set -e
    cd "${MAKE_SCRIPT_DIR}/Masscan"
    make
    mkdir -p "${PATH_MASSCAN}"
    cp "${MAKE_SCRIPT_DIR}/Masscan/bin/masscan" "${PATH_MASSCAN}"
    ln -s "${PATH_MASSCAN}/masscan" /usr/bin/masscan
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/Masscan"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/masscan
    rm -rf "${PATH_MASSCAN}"
    exit 0
)}
