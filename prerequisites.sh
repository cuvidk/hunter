#!/bin/sh

. ./util.sh

STDOUT_LOG='stdout.log'
STDERR_LOG='stderr.log'

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

#########################################################################

install_packages() {
    for package in ${PACKAGES}; do
        perform_task_arg install_package ${package} "Installing package ${package} "
    done
}

install_config_files() {
    local ret=0j
    cd ./config-files
    if [ $? -eq 0 ]; then
        ./update_config --config vim
        ret=$?
        cd ..
    fi
    return ${ret}
}

#########################################################################

if [ -t 1 ]; then
    "${0}" "${@}" >"${STDOUT_LOG}" 2>${STDERR_LOG}
    exit 0
fi

perform_task install_packages
perform_task install_config_files

errors_encountered &&
    print_msg "ERR: ${0} finished with errors. Check ${STDERR_LOG} / ${STDOUT_LOG} for details.\n" ||
    print_msg "${0} finished with success.\n"
