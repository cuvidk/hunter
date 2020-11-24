pre_install() {
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/devanshbatham/FavFreak" "${MAKE_SCRIPT_DIR}/FavFreak"
}

install() {(
    set -e
    mkdir -p "${PATH_FAVFREAK}"
    pip install -r "${MAKE_SCRIPT_DIR}/FavFreak/requirements.txt"
    cp "${MAKE_SCRIPT_DIR}/FavFreak/favfreak.py" "${PATH_FAVFREAK}"
    chmod +x "${PATH_FAVFREAK}/favfreak.py"
    ln -s "${PATH_FAVFREAK}/favfreak.py" /usr/bin/favfreak
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/FavFreak"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/favfreak
    rm -rf "${PATH_FAVFREAK}"
    exit 0
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}
