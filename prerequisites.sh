#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

install_package() {
    local package_name=$1
    pacman -S --noconfirm --needed "${package_name}"
}

install_packages() {
    local packages="sudo
                    man-db
                    man-pages
                    texinfo
                    wget
                    base-devel
                    git
                    python-pip
                    iputils
                    iproute2
                    chromium"

    local custom_packages="vim
                           zsh"

    for package in ${packages}; do
        perform_task_arg install_package ${package} "installing package ${package}"
    done

    for package in ${custom_packages}; do
        "${SCRIPT_DIR}/config-files/${package}/${package}.sh" install
    done
}

main() {
    setup_verbosity "${@}"

    perform_task install_packages

    check_for_errors
}

main "${@}"
