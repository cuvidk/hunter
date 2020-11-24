pre_install() {
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/yassineaboukir/Asnlookup" "${MAKE_SCRIPT_DIR}/Asnlookup"
}

install() {(
    set -e
    pip install -r "${MAKE_SCRIPT_DIR}/Asnlookup/requirements.txt"
    mkdir -p "${PATH_ASNLOOKUP}"
    cp "${MAKE_SCRIPT_DIR}/Asnlookup/asnlookup.py" "${PATH_ASNLOOKUP}"
    chmod +x "${PATH_ASNLOOKUP}/asnlookup.py"
    ln -s "${PATH_ASNLOOKUP}/asnlookup.py" /usr/bin/asnlookup
    rm -rf "${MAKE_SCRIPT_DIR}/Asnlookup"
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/Asnlookup"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/asnlookup
    rm -rf "${PATH_ASNLOOKUP}"
    exit 0
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}
