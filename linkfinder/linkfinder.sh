pre_install() {
    pacman -S --noconfirm --needed python-pip
}

install() {(
    set -e
    git clone 'https://github.com/GerbenJavado/LinkFinder.git' "${PATH_LINKFINDER}"
    cd "${PATH_LINKFINDER}"
    python3 setup.py install --record "${PATH_LINKFINDER}/uninstall.txt"
    ln -s "${PATH_LINKFINDER}/linkfinder.py" /usr/bin/linkfinder
)}

uninstall() {(
    set -e
    [ -e "${PATH_LINKFINDER}/uninstall.txt" ] &&
        cat "${PATH_LINKFINDER}/uninstall.txt" | xargs -I{} rm -rf {}
    rm -rf "${PATH_LINKFINDER}"
    rm -rf /usr/bin/linkfinder
)}
