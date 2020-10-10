#!/bin/sh

###################### INSTALL ######################

install_golang() {
    pacman -S --needed --noconfirm go
    mkdir -p "${GO_PACKAGE_PATH}"
    chown -R "${g_user}:${g_user}" "${GO_PACKAGE_PATH}"
    echo "export GOPATH=${GO_PACKAGE_PATH}" >"/etc/profile.d/go.sh"
    echo "export GO111MODULE=on" >>"/etc/profile.d/go.sh"
    . /etc/profile.d/go.sh
}

install_assetfinder() {
    sudo -H -E -u "${g_user}" go get -u github.com/tomnomnom/assetfinder
    ln -s "$GO_PACKAGE_PATH/bin/assetfinder" /usr/bin/assetfinder
}

install_httprobe() {
    sudo -H -E -u "${g_user}" go get -u github.com/tomnomnom/httprobe
    ln -s "$GO_PACKAGE_PATH/bin/httprobe" /usr/bin/httprobe
}

install_amass() {
    sudo -H -E -u "${g_user}" go get -v github.com/OWASP/Amass/v3/...
    ln -s "${GO_PACKAGE_PATH}/bin/amass" /usr/bin/amass
    git clone "https://github.com/OWASP/Amass" "${WORKING_DIR}/Amass"
    mkdir -p /opt/wordlists/amass
    cp "${WORKING_DIR}/Amass/examples/wordlists/*" /opt/wordlists/amass
    rm -rf "${WORKING_DIR}/Amass"
}

install_eyewitness() {
    git clone https://github.com/cuvidk/EyeWitness.git "${EYEWITNESS_PATH}"
    chown -R "${g_user}:${g_user}" "${EYEWITNESS_PATH}"
    cd "${EYEWITNESS_PATH}"
    git checkout fix-recursive-symlink-and-bad-pkg-name-arch
    sh "${EYEWITNESS_PATH}/Python/setup/setup.sh"
    ln -s "${EYEWITNESS_PATH}/Python/EyeWitness.py" /usr/bin/eyewitness
    cd -

    # the following issue should be fixed upstream instead; i submitted a pullrequest
    # to their git repository

    #rm -rf /usr/bin/geckodriver
    #geckodriver_x86_64='https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz'
    #wget ${geckodriver_x86_64}
    #tar -xvf geckodriver-v0.26.0-linux64.tar.gz
    #rm geckodriver-v0.26.0-linux64.tar.gz
    #mv geckodriver /usr/bin/geckodriver

    # # firefox is not installed because python3-netaddr is not a valid package (fix this upstream)
    #for package in python-netaddr firefox; do
    #    pacman -S --noconfirm "${package}"
    #done
}

install_subfinder() {
    local version="2.4.5"
    mkdir "${WORKING_DIR}/subfinder"
    cd "${WORKING_DIR}/subfinder"
    wget "https://github.com/projectdiscovery/subfinder/releases/download/v${version}/subfinder_${version}_linux_amd64.tar.gz"
    tar -xzvf "subfinder_${version}_linux_amd64.tar.gz"
    mv subfinder /usr/bin/
    cd -
    rm -rf "${WORKING_DIR}/subfinder"
}

fix_wordlists_owner() {
    chown -R "${g_user}:${g_user}" /opt/wordlists
}

install_all() {
    install_golang
    #install_assetfinder
    install_httprobe
    #install_eyewitness
    install_amass
    install_subfinder
    fix_wordlists_owner
}

###################### UNINSTALL ######################

remove_golang() {
    pacman -Rs --noconfirm go
    rm -rf /opt/go
    rm -rf /etc/profile.d/go.sh
}

remove_assetfinder() {
    rm -rf /usr/bin/assetfinder
}

remove_httprobe() {
    rm -rf /usr/bin/httprobe
}

remove_amass() {
    rm -rf /usr/bin/amass
}

remove_eyewitness() {
    rm -rf /opt/eyewitness
    rm -rf /usr/bin/eyewitness
    # eyewitness has a custom installer that installs
    # a lot of dependencies; I cannot delete those manually
    # because a lot of them may be required by other software
}

remove_subfinder() {
    rm -rf /usr/bin/subfinder
}

remove_wordlists() {
    rm -rf /opt/wordlists
}

remove_all() {
    remove_golang
    #remove_assetfinder
    remove_httprobe
    #remove_eyewitness
    remove_amass
    remove_subfinder
    remove_wordlists
}

#######################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

#. "${WORKING_DIR}/util.sh"

GO_PACKAGE_PATH="/opt/go"
EYEWITNESS_PATH="/opt/eyewitness"

usage() {
    echo "Usage: ${0} <install|remove> [--user <user_owning_tools>]"
}

if [ $(id -u) -ne 0 ]; then
    echo "Run this as root."
    exit 1
fi

case "${1}" in
    "install")
        operation=install_all
        shift
        ;;
    "remove")
        operation=remove_all
        shift
        ;;
    *)
        usage
        exit 2
        ;;
esac

g_user="root"
if [ $# -gt 0 ]; then
    case "${1}" in
        "--user")
            g_user="${2}"
            ;;
        *)
            usage
            exit 3
            ;;
    esac
fi

if [ "$(cat /etc/passwd | grep "${g_user}" | cut -d ':' -f1)" != "${g_user}" ]; then
    echo "Unknown user ${g_user}"
    exit 4
fi

${operation}
