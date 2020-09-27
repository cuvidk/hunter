#!/bin/sh

GO_PACKAGE_PATH="/opt/go"
EYEWITNESS_PATH="/opt/eyewitness"

if [ `id -u` -ne 0 ]; then
    echo "Usage: sudo ${0} <install|remove>"
    exit 1
fi

install_golang() {
    pacman -S --needed --noconfirm go
    mkdir -p "${GO_PACKAGE_PATH}"
    chown -R "${SUDO_USER}:${SUDO_USER}" "${GO_PACKAGE_PATH}"
    echo "export GOPATH=${GO_PACKAGE_PATH}" >"/etc/profile.d/go.sh"
    echo "export GO111MODULE=on" >>"/etc/profile.d/go.sh"
    . /etc/profile.d/go.sh
}

remove_golang() {
    pacman -Rs --noconfirm go
    rm -rf /opt/go
    rm -rf /etc/profile.d/go.sh
}

install_assetfinder() {
    sudo -H -E -u "${SUDO_USER}" go get -u github.com/tomnomnom/assetfinder
    ln -s "$GO_PACKAGE_PATH/bin/assetfinder" /usr/bin/assetfinder
}

remove_assetfinder() {
    rm -rf /usr/bin/assetfinder
}

install_httprobe() {
    sudo -H -E -u "${SUDO_USER}" go get -u github.com/tomnomnom/httprobe
    ln -s "$GO_PACKAGE_PATH/bin/httprobe" /usr/bin/httprobe
}

remove_httprobe() {
    rm -rf /usr/bin/httprobe
}

install_amass() {
    sudo -H -E -u "${SUDO_USER}" go get -v github.com/OWASP/Amass/v3/...
    ln -s "${GO_PACKAGE_PATH}/bin/amass" /usr/bin/amass
    git clone "https://github.com/OWASP/Amass"
    mkdir -p /opt/wordlists/amass
    cp ./Amass/examples/wordlists/* /opt/wordlists/amass
    chown -R "${SUDO_USER}:${SUDO_USER}" /opt/wordlists/amass
    rm -rf ./Amass
}

remove_amass() {
    rm -rf /usr/bin/amass
}

install_eyewitness() {
    git clone https://github.com/cuvidk/EyeWitness.git "$EYEWITNESS_PATH"
    chown -R "${SUDO_USER}:${SUDO_USER}" "${EYEWITNESS_PATH}"
    cd "$EYEWITNESS_PATH"
    git checkout fix-recursive-symlink-and-bad-pkg-name-arch
    sh "$EYEWITNESS_PATH/Python/setup/setup.sh"
    ln -s "$EYEWITNESS_PATH/Python/EyeWitness.py" /usr/bin/eyewitness

    # the following issue should be fixed upstream instead; i submitted a pullrequest
    # to their git repository

    #rm -rf /usr/bin/geckodriver
    #geckodriver_x86_64='https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz'
    #wget ${geckodriver_x86_64}
    #tar -xvf geckodriver-v0.26.0-linux64.tar.gz
    #rm geckodriver-v0.26.0-linux64.tar.gz
    #mv geckodriver /usr/bin/geckodriver

    # # firefox is not installed because python3-netaddr is not a valid package (fix this upstream)
    #for package in python-netaddr firefox; do
    #    pacman -S --noconfirm "${package}"
    #done
}

remove_eyewitness() {
    rm -rf /opt/eyewitness
    rm -rf /usr/bin/eyewitness
    # eyewitness has a custom installer that installs
    # a lot of dependencies; I cannot delete those manually
    # because a lot of them may be required by other software
}

install_all() {
    install_golang
    #install_assetfinder
    install_httprobe
    install_eyewitness
    install_amass
}

remove_all() {
    remove_golang
    #remove_assetfinder
    remove_httprobe
    remove_eyewitness
    remove_amass
}

case "${1}" in
    "install")
        install_all
        ;;
    "remove")
        remove_all
        ;;
    *)
        echo "Usage: sudo ${0} <install|remove>"
        ;;
esac
