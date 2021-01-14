install() {(
    set -e
    local user="${SUDO_USER:-$USER}"
    sudo -u "${user}" git clone https://aur.archlinux.org/aquatone.git src-aquatone
    cd src-aquatone
    #TODO: This won't work if root is running the script
    sudo -u "${user}" makepkg -si --noconfirm
)}

post_install() {
    rm -rf src-aquatone
}

uninstall() {
    pacman -Rs --noconfirm aquatone
}
