pre_install() {
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/vysecurity/DomLink.git" "${MAKE_SCRIPT_DIR}/DomLink"
}

install() {(
    set -e
    pip install -r "${MAKE_SCRIPT_DIR}/DomLink/requirements.txt"
    mkdir -p "${PATH_DOMLINK}"
    cp "${MAKE_SCRIPT_DIR}/DomLink/domLink.py" "${PATH_DOMLINK}"
    chmod +x "${PATH_DOMLINK}/domLink.py"
    ln -s "${PATH_DOMLINK}/domLink.py" /usr/bin/domlink
    exit 0
)}

post_install() {(
    set -e
    rm -rf "${MAKE_SCRIPT_DIR}/DomLink"
    "${MAKE_SCRIPT_DIR}/domlink/domlink_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/domlink/domlink_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/domlink
    rm -rf "${PATH_DOMLINK}"
    exit 0
)}

post_uninstall() {
    "${MAKE_SCRIPT_DIR}/domlink/domlink_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/domlink/domlink_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    pacman -Rs --noconfirm python-pip
}
