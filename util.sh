#!/bin/sh

g_err_flag=0

print_msg() {
    echo -n -e "$1">>$(tty)
}

perform_task() {
    local task=$1
    local message=$2
    [ -n "${message}" ] && print_msg "${message}\r"
    ${task}
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
    ${task} ${arg}
    local ret=$?
    if [ ${ret} -eq 0 ]; then
        [ -n "${message}" ] && print_msg "[ OK ] ${message}\n"
    else
        [ -n "${message}" ] && print_msg "[ FAIL ] ${message}\n"
        g_err_flag=1
    fi
    return ${ret}
}

errors_encountered() {
    [ ${g_err_flag} -eq 1 ]
}
