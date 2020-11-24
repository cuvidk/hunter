pre_install() {
    pacman -S --noconfirm --needed python-pip
    git clone "https://github.com/nsonaniya2010/SubDomainizer.git" "${MAKE_SCRIPT_DIR}/SubDomainizer"
}

install() {(
    set -e
    pip install -r "${MAKE_SCRIPT_DIR}/SubDomainizer/requirements.txt"
    mkdir "${PATH_SUBDOMAINIZER}"
    cp "${MAKE_SCRIPT_DIR}/SubDomainizer/SubDomainizer.py" "${PATH_SUBDOMAINIZER}"
    chmod +x "${PATH_SUBDOMAINIZER}/SubDomainizer.py"
    ln -s "${PATH_SUBDOMAINIZER}/SubDomainizer.py" /usr/bin/subdomainizer
    exit 0
)}

post_install() {
    rm -rf "${MAKE_SCRIPT_DIR}/SubDomainizer"
}

uninstall() {(
    set -e
    rm -rf /usr/bin/subdomainizer
    rm -rf "${PATH_SUBDOMAINIZER}"
    exit 0
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}
