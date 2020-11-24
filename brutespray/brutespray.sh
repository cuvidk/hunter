pre_install() {(
    set -e
    pacman -S --noconfirm --needed medusa
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/x90skysn3k/brutespray.git" "${MAKE_SCRIPT_DIR}/Brutespray"
    exit 0
)}

install() {(
    set -e
    mkdir -p "${PATH_BRUTESPRAY}"
    pip install -r "${MAKE_SCRIPT_DIR}/Brutespray/requirements.txt"
    cp "${MAKE_SCRIPT_DIR}/Brutespray/brutespray.py" "${PATH_BRUTESPRAY}"
    ln -s "${PATH_BRUTESPRAY}/brutespray.py" /usr/bin/brutespray
    cp -r "${MAKE_SCRIPT_DIR}/Brutespray/wordlist/" "${PATH_BRUTESPRAY_WORDLISTS}"
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/Brutespray"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/brutespray
    rm -rf "${PATH_BRUTESPRAY}"
    rm -rf "${PATH_BRUTESPRAY_WORDLISTS}"
    exit 0
)}

post_uninstall() {(
    set -e
    pacman -Rs --noconfirm medusa
    pacman -Rs --noconfirm python-pip
    exit 0
)}
