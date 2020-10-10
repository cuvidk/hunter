#!/bin/sh

g_err_flag=0

setup_output() {
    WORKING_DIR="$(realpath "$(dirname "${0}")")"
    OUT_REDIRECTED="$(realpath "${0}").log"
    [ -e /proc/$$/fd/1 ] && OUT="$(realpath /proc/$$/fd/1)"
    exec 1>"${OUT_REDIRECTED}" 2>&1
}

print_msg() {
    if [ -n "${OUT}" ]; then
        echo -n -e "$1">>${OUT}
    else
        echo -n -e "$1"
    fi
}

perform_task() {
    local task=$1
    local message=$2
    [ -n "${message}" ] && print_msg "${message}\r"
    echo "#################################################"
    echo "                   ${message}                    "
    echo "#################################################"
    ${task}
    echo "#################################################"
    local ret=$?
    if [ ${ret} -eq 0 ]; then
        [ -n "${message}" ] && print_msg "[ OK ] ${message}\n"
    else
        [ -n "${message}" ] && print_msg "[ FAIL ] ${message}\n"
        g_err_flag=1
    fi
    return ${ret}
}

perform_task_arg() {
    local task=$1
    local arg=$2
    local message=$3
    [ -n "${message}" ] && print_msg "${message}\r"
    echo "#################################################"
    echo "                   ${message}                    "
    echo "#################################################"
    ${task} ${arg}
    echo "#################################################"
    local ret=$?
    if [ ${ret} -eq 0 ]; then
        [ -n "${message}" ] && print_msg "[ OK ] ${message}\n"
    else
        [ -n "${message}" ] && print_msg "[ FAIL ] ${message}\n"
        g_err_flag=1
    fi
    return ${ret}
}

check_for_errors() {
    [ ${g_err_flag} -eq 1 ] &&
        print_msg "[ WARNING ]: ${0} finished with errors. See ${OUT_REDIRECTED} for details.\n" ||
        print_msg "[ SUCCESS ]: ${0} finished with success."
}
