#!/bin/sh

#########################################################################

install_package() {
    local package_name=$1
    pacman -S --noconfirm --needed "${package_name}"
}

install_packages() {
    for package in ${PACKAGES}; do
        perform_task_arg install_package ${package} "Installing package ${package}"
    done
}

install_ohmyzsh() {
    "${WORKING_DIR}/config-files/installers/ohmyzsh.sh" install
}

install_config_files() {
    "${WORKING_DIR}/config-files/update_config.sh" --config vim
    "${WORKING_DIR}/config-files/update_config.sh" --config zsh
}

#########################################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"
. "${WORKING_DIR}/config-files/shell-utils/util.sh"

# setup_output

PACKAGES="vim
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
          "

perform_task install_packages
perform_taks install_ohmyzsh
perform_task install_config_files

check_for_errors
