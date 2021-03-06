pre_install() {
    git clone 'https://github.com/blechschmidt/massdns.git' "${MAKE_SCRIPT_DIR}/Massdns"
}

install() {(
    set -e
    cd "${MAKE_SCRIPT_DIR}/Massdns"
    make
    mkdir -p "${PATH_MASSDNS}"
    cp "${MAKE_SCRIPT_DIR}/Massdns/bin/massdns" "${PATH_MASSDNS}"
    cp -R "${MAKE_SCRIPT_DIR}/Massdns/lists" "${PATH_MASSDNS}"
    echo '#!/bin/sh' >>"${PATH_MASSDNS}/massdns.sh"
    echo "${PATH_MASSDNS}/massdns" '${@}' "-r ${PATH_RESOLVERS}/nameservers.txt" >>"${PATH_MASSDNS}/massdns.sh"
    chmod +x "${PATH_MASSDNS}/massdns.sh"
    ln -s "${PATH_MASSDNS}/massdns.sh" /usr/bin/massdns
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/Massdns"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/massdns
    rm -rf "${PATH_MASSDNS}"
    exit 0
)}
