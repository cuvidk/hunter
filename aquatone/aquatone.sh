AUR_USER='aur-user'

pre_install() {(
    set -e
    useradd -d "/tmp/${AUR_USER}" "${AUR_USER}"
    # TODO: This is very dangerous. Can I find a workaround ?
    echo "${AUR_USER} ALL=(ALL) NOPASSWD: ALL" >>"/etc/sudoers.d/${AUR_USER}"
    exit 0
)}

install() {(
    set -e
    sudo -u "${AUR_USER}" git clone https://aur.archlinux.org/aquatone.git /tmp/src-aquatone
    cd /tmp/src-aquatone
    sudo -u "${AUR_USER}" makepkg -si --noconfirm
    exit 0
)}

post_install() {
    rm -rf /tmp/src-aquatone
    userdel "${AUR_USER}"
    rm -rf "/etc/sudoers.d/${AUR_USER}"
    rm -rf "/tmp/${AUR_USER}"
}

uninstall() {
    pacman -Rs --noconfirm aquatone
}
