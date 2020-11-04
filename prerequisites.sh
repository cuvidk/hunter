#!/bin/sh

WORKING_DIR="$(realpath "$(dirname "${0}")")"
. "${WORKING_DIR}/config-files/shell-utils/util.sh"

install_package() {
    local package_name=$1
    pacman -S --noconfirm --needed "${package_name}"
}

install_packages() {
    local packages="vim
              sudo
              man-db
              man-pages
              texinfo
              wget
              base-devel
              git
              zsh
              python-pip
              iputils
              iproute2
              chromium
              "

    for package in ${packages}; do
        perform_task_arg install_package ${package} "Installing package ${package}"
    done
}

install_ohmyzsh() {
    "${WORKING_DIR}/config-files/installers/ohmyzsh.sh" install ${VERBOSE}
    chsh -s /bin/zsh
}

install_golang() {
    "${WORKING_DIR}/config-files/installers/golang.sh" install ${VERBOSE}
}

install_config_files() {
    "${WORKING_DIR}/config-files/update_config.sh" --config vim ${VERBOSE}
    "${WORKING_DIR}/config-files/update_config.sh" --config zsh ${VERBOSE}
    "${WORKING_DIR}/config-files/update_config.sh" --config go ${VERBOSE}
}

main() {
    setup_verbosity "${@}"

    perform_task install_packages
    perform_task install_ohmyzsh
    perform_task install_golang
    perform_task install_config_files

    check_for_errors
}

main "${@}"
