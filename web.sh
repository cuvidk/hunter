#!/bin/sh

PACKAGES="go\
         "
GO_PACKAGE_PATH="/opt/go"
EYEWITNESS_PATH="/opt/eyewitness"

if [ `id -u` -ne 0 ]; then
    echo "Usage: sudo $0"
    exit 1
fi

install_golang() {
    pacman -S --needed --noconfirm go
    mkdir -p "$GO_PACKAGE_PATH"
    export GOPATH="$GO_PACKAGE_PATH"
    echo "export GOPATH=$GO_PACKAGE_PATH" >"/etc/profile.d/go.sh"
}

install_assetfinder() {
    go get -u github.com/tomnomnom/assetfinder
    ln -s "$GO_PACKAGE_PATH/bin/assetfinder" /usr/bin/assetfinder
}

install_httprobe() {
    go get -u github.com/tomnomnom/httprobe
    ln -s "$GO_PACKAGE_PATH/bin/httprobe" /usr/bin/httprobe
}

install_eyewitness() {
    git clone https://github.com/cuvidk/EyeWitness.git "$EYEWITNESS_PATH"
    cd "$EYEWITNESS_PATH"
    git checkout fix-recursive-symlink-and-bad-pkg-name-arch
    sh "$EYEWITNESS_PATH/Python/setup/setup.sh"
    ln -s "$EYEWITNESS_PATH/Python/EyeWitness.py" /usr/bin/eyewitness

    # the following issue should be fixed upstream instead; i submitted an issue
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

install_golang
install_assetfinder
install_httprobe
install_eyewitness
