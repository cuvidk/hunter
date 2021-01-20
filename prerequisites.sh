#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

install_package() {
    local package_name=$1
    pacman -S --noconfirm --needed "${package_name}"
}

install_custom_package() {
    local package_name=$1
    "${SCRIPT_DIR}/config-files/make.sh" install "${package_name}" ${VERBOSE}
}

install_packages() {
    local packages="sudo
                    man-db
                    man-pages
                    texinfo
                    wget
                    base-devel
                    git
                    iputils
                    iproute2
                    chromium
                    tmux
                    ntp"

    local custom_packages="vim
                           zsh"

    pacman -Syu --noconfirm

    for package in ${packages}; do
        perform_task_arg install_package ${package} "installing package ${package}"
    done

    for package in ${custom_packages}; do
        perform_task_arg install_custom_package "${package}"
    done
}

main() {
    setup_verbosity "${@}"

    install_packages

    check_for_errors
}

main "${@}"
