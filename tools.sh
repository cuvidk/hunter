#!/bin/sh

main() {
    local packages='nmap
                    medusa
                    sqlmap'
    for package in ${packages}; do
        pacman -S --noconfirm --needed "${package}"
    done
}

main()
