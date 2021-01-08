install() {(
    set -e
    local version="2.4.5"
    mkdir -p "${MAKE_SCRIPT_DIR}/Subfinder"
    cd "${MAKE_SCRIPT_DIR}/Subfinder"
    wget "https://github.com/projectdiscovery/subfinder/releases/download/v${version}/subfinder_${version}_linux_amd64.tar.gz"
    tar -xzvf "subfinder_${version}_linux_amd64.tar.gz"
    mkdir -p "${PATH_SUBFINDER}"
    mv subfinder "${PATH_SUBFINDER}"
    echo '#!/bin/sh' >"${PATH_SUBFINDER}/subfinder.sh"
    echo "${PATH_SUBFINDER}/subfinder" '${@}' -config "${PATH_SUBFINDER_CONFIG}" >>"${PATH_SUBFINDER}/subfinder.sh"
    chmod +x "${PATH_SUBFINDER}/subfinder.sh"
    ln -s "${PATH_SUBFINDER}/subfinder.sh" /usr/bin/subfinder
    cd -
    rm -rf "${MAKE_SCRIPT_DIR}/Subfinder"
    exit 0
)}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install subfinder "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install subfinder "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subfinder
    rm -rf "${PATH_SUBFINDER}"
    exit 0
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall subfinder "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall subfinder "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
