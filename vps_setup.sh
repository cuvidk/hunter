#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/config-files/shell-utils/util.sh"

setup_localization() {
    sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen &&
        locale-gen &&
        echo 'LANG=en_US.UTF-8' >/etc/locale.conf
}

main() {
    setup_verbosity "${@}"

    "${SCRIPT_DIR}/prerequisites.sh"
    perform_task setup_localization "Setting up localization"

    check_for_errors
}

main "${@}"
