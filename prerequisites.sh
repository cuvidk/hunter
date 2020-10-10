#!/bin/sh

#########################################################################

install_package() {
    local package_name=$1
    pacman -S --noconfirm "${package_name}"
}

install_packages() {
    for package in ${PACKAGES}; do
        perform_task_arg install_package ${package} "Installing package ${package} "
    done
}

install_config_files() {
    ./config-files/update_config.sh --config vim
}

#########################################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/util.sh"

STDOUT_LOG="${WORKING_DIR}/stdout.log"
STDERR_LOG="${WORKING_DIR}/stderr.log"

PACKAGES="vim
          man-db
          man-pages
          texinfo
          wget
	  base-devel
          git
          zsh
          sudo
          "

if [ -t 1 ]; then
    "${0}" "${@}" >"${STDOUT_LOG}" 2>${STDERR_LOG}
    exit 0
fi

perform_task install_packages
perform_task install_config_files

errors_encountered &&
    print_msg "ERR: ${0} finished with errors. Check ${STDERR_LOG} / ${STDOUT_LOG} for details.\n" ||
    print_msg "${0} finished with success.\n"
