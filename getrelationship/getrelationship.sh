pre_install() {(
    set -e
    pacman -S --noconfirm --needed python-pip
    pip install requests
    pip install lxml
    exit 0
)}

install() {(
    set -e
    # THIS ONE MAY CAUSE PROBLEMS
    wget "https://raw.githubusercontent.com/m4ll0k/Bug-Bounty-Toolz/master/getrelationship.py"
    mkdir -p "${PATH_GETRELATIONSHIP}"
    echo '#!/usr/bin/python3' >"${PATH_GETRELATIONSHIP}/getrelationship.py"
    cat getrelationship.py >>"${PATH_GETRELATIONSHIP}/getrelationship.py"
    chmod +x "${PATH_GETRELATIONSHIP}/getrelationship.py"
    ln -s "${PATH_GETRELATIONSHIP}/getrelationship.py" /usr/bin/getrelationship
    rm -rf getrelationship.py
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/getrelationship
    rm -rf "${PATH_GETRELATIONSHIP}"
    exit 0
)}

post_uninstall() {
    pacman -Rs --noconfirm python-pip
}
