#!/bin/sh

###################### INSTALL ######################

install_subscraper() {
    git clone "https://github.com/m8r0wn/subscraper" "${WORKING_DIR}/subscraper"
    cd "${WORKING_DIR}/subscraper"
    python3 setup.py install
    pip install ipparser
    mkdir "${SUBSCRAPER_PATH}"
    mv /usr/bin/subscraper "${SUBSCRAPER_PATH}/subscraper"
    echo '#!/bin/sh' >"${SUBSCRAPER_PATH}/subscraper.sh"
    echo "${SUBSCRAPER_PATH}/subscraper --censys-api ${CENSYS_API_KEY} --censys-secret ${CENSYS_SECRET}" '${@}' >>"${SUBSCRAPER_PATH}/subscraper.sh"
    chmod +x "${SUBSCRAPER_PATH}/subscraper.sh"
    chown -R "${g_user}:${g_user}" "${SUBSCRAPER_PATH}"
    ln -s "${SUBSCRAPER_PATH}/subscraper.sh" /usr/bin/subscraper
    cd -
    rm -rf "${WORKING_DIR}/subscraper"
}

install_shosubgo() {
    git clone "https://github.com/incogbyte/shosubgo" "${SHOSUBGO_PATH}"
    echo '#!/bin/sh' >"${SHOSUBGO_PATH}/shosubgo.sh"
    echo "go run ${SHOSUBGO_PATH}/main.go -s ${SHODAN_API_KEY}" '${@}' >>"${SHOSUBGO_PATH}/shosubgo.sh"
    chmod +x "${SHOSUBGO_PATH}/shosubgo.sh"
    ln -s "${SHOSUBGO_PATH}/shosubgo.sh" /usr/bin/shosubgo
    chown -R "${g_user}:${g_user}" "${SHOSUBGO_PATH}"
}

install_github_search() {
    git clone "https://github.com/gwen001/github-search.git" "${GITHUB_SEARCH_PATH}"
    chown -R "${g_user}:${g_user}" "${GITHUB_SEARCH_PATH}"
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

install_nmap() {
    pacman -S --noconfirm nmap
}

install_medusa() {
    pacman -S --noconfirm medusa
}

install_sqlmap() {
    pacman -S --noconfirm sqlmap
}

create_wordlist() {
    mkdir -p "${WORDLISTS_PATH}"
}

fix_wordlists_owner() {
    chown -R "${g_user}:${g_user}" "${WORDLISTS_PATH}"
}

install_all() {
    #install_eyewitness
    create_wordlist
    install_subscraper
    install_shosubgo
    install_github_search
    install_nmap
    install_medusa
    install_sqlmap
    fix_wordlists_owner
}

###################### UNINSTALL ######################

remove_subscraper() {
    rm -rf "${SUBSCRAPER_PATH}"
    rm -rf /usr/bin/subscraper
}

remove_shosubgo() {
    rm -rf "${SHOSUBGO_PATH}"
    rm -rf /usr/bin/shosubgo
}

remove_github_search() {
    rm -rf "${GITHUB_SEARCH_PATH}"
}

remove_eyewitness() {
    rm -rf "${EYEWITNESS_PATH}"
    rm -rf /usr/bin/eyewitness
    # eyewitness has a custom installer that installs
    # a lot of dependencies; I cannot delete those manually
    # because a lot of them may be required by other software
}

remove_nmap() {
    pacman -Rs --noconfirm nmap
}

remove_medusa() {
    pacman -Rs --noconfirm medusa
}

remove_sqlmap() {
    pacman -Rs --noconfirm sqlmap
}

remove_wordlists() {
    rm -rf "${WORDLISTS_PATH}"
}

remove_all() {
    #remove_eyewitness
    remove_subscraper
    remove_shosubgo
    remove_github_search
    remove_nmap
    remove_medusa
    remove_sqlmap
    remove_wordlists
}

#######################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/config-files/install_paths.sh"

export GOPATH="${PATH_GOLANG}"
GO_PACKAGE_PATH="${PATH_GOLANG}"

EYEWITNESS_PATH='/opt/eyewitness'
SUBSCRAPER_PATH='/opt/subscraper'
SHOSUBGO_PATH='/opt/shosubgo'
GITHUB_SEARCH_PATH='/opt/github-search'

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
