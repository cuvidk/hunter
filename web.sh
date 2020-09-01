#!/bin/sh

PACKAGES="go\
         "
GO_PACKAGE_PATH="/opt/go"

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

install_golang
install_assetfinder
install_httprobe
