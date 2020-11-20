#!/bin/sh

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

parse_cmd() {
    case "${1}" in
        "install")
            action=install
            shift
            ;;
        "uninstall")
            action=uninstall
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    USER=
    while [ $# -gt 0 ]; do
        case "${1}" in
            "--for-user")
                USER="${2}"
                break
                ;;
            *)
                shift
                ;;
        esac
    done

    [ -z "${USER}" ] && usage && exit 2
    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${USER}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && usage && exit 3
}
