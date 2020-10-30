#!/bin/sh

main() {
    wget https://raw.githubusercontent.com/gh2o/digitalocean-debian-to-arch/debian9/install.sh -O install.sh
    bash install.sh --extra_packages "git kitty-terminfo"
}

main "${@}"
