#!/bin/sh

###################### INSTALL ######################

install_metabigor() {
    sudo -H -E -u "${g_user}" go get -u github.com/j3ssie/metabigor
    ln -s "${GO_PACKAGE_PATH}/bin/metabigor" /usr/bin/metabigor
}

install_asnlookup() {
    git clone "https://github.com/yassineaboukir/Asnlookup" "${WORKING_DIR}/Asnlookup"
    pip install -r "${WORKING_DIR}/Asnlookup/requirements.txt"
    mkdir "${ASNLOOKUP_PATH}"
    cp "${WORKING_DIR}/Asnlookup/asnlookup.py" "${ASNLOOKUP_PATH}"
    chmod +x "${ASNLOOKUP_PATH}/asnlookup.py"
    cp "${WORKING_DIR}/Asnlookup/config.py" "${ASNLOOKUP_PATH}"
    chown -R "${g_user}:${g_user}" "${ASNLOOKUP_PATH}"
    ln -s "${ASNLOOKUP_PATH}/asnlookup.py" /usr/bin/asnlookup
    rm -rf "${WORKING_DIR}/Asnlookup"
}

install_domlink() {
    git clone "https://github.com/vysecurity/DomLink.git" "${WORKING_DIR}/DomLink"
    pip install -r "${WORKING_DIR}/DomLink/requirements.txt"
    mkdir "${DOMLINK_PATH}"
    cp "${WORKING_DIR}/DomLink/domLink.py" "${DOMLINK_PATH}"
    chmod +x "${DOMLINK_PATH}/domLink.py"
    # API KEY
    mv "${WORKING_DIR}/DomLink/domLink.cfg.example" "${DOMLINK_PATH}/domLink.cfg"
    chown -R "${g_user}:${g_user}" "${DOMLINK_PATH}"
    ln -s "${DOMLINK_PATH}/domLink.py" /usr/bin/domlink
    rm -rf "${WORKING_DIR}/DomLink"
}

install_getrelationship() {
    wget "https://raw.githubusercontent.com/m4ll0k/Bug-Bounty-Toolz/master/getrelationship.py"
    mkdir "${GETRELATIONSHIP_PATH}"
    mv getrelationship.py "${GETRELATIONSHIP_PATH}/getrelationship.py"
    chmod +x "${GETRELATIONSHIP_PATH}/getrelationship.py"
    chown -R "${g_user}:${g_user}" "${GETRELATIONSHIP_PATH}"
    ln -s "${GETRELATIONSHIP_PATH}/getrelationship.py" /usr/bin/getrelationship
}

install_gospider() {
    sudo -E -H -u "${g_user}" go get -u github.com/jaeles-project/gospider
    ln -s "${GO_PACKAGE_PATH}/bin/gospider" /usr/bin/gospider
}

install_hakrawler() {
    sudo -E -H -u "${g_user}" go get -u github.com/hakluke/hakrawler
    ln -s "${GO_PACKAGE_PATH}/bin/hakrawler" /usr/bin/hakrawler
}

install_subdomainizer() {
    git clone "https://github.com/nsonaniya2010/SubDomainizer.git" "${WORKING_DIR}/SubDomainizer"
    pip install -r "${WORKING_DIR}/SubDomainizer/requirements.txt"
    mkdir "${SUBDOMAINIZER_PATH}"
    cp "${WORKING_DIR}/SubDomainizer/SubDomainizer.py" "${SUBDOMAINIZER_PATH}"
    chmod +x "${SUBDOMAINIZER_PATH}/SubDomainizer.py"
    chown -R "${g_user}:${g_user}" "${SUBDOMAINIZER_PATH}"
    ln -s "${SUBDOMAINIZER_PATH}/SubDomainizer.py" /usr/bin/subdomainizer
    rm -rf "${WORKING_DIR}/SubDomainizer"
}

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

install_github_subdomains() {
    sudo -E -H -u "${g_user}" go get -u github.com/gwen001/github-subdomains
    ln -s "${GO_PACKAGE_PATH}/bin/github-subdomains" /usr/bin/github-subdomains
}

install_github_search() {
    git clone "https://github.com/gwen001/github-search.git" "${GITHUB_SEARCH_PATH}"
    chown -R "${g_user}:${g_user}" "${GITHUB_SEARCH_PATH}"
}

install_assetfinder() {
    export GO111MODULE=on
    sudo -H -E -u "${g_user}" go get -u github.com/tomnomnom/assetfinder
    unset GO111MODULE
    ln -s "${GO_PACKAGE_PATH}/bin/assetfinder" /usr/bin/assetfinder
}

install_httprobe() {
    export GO111MODULE=on
    sudo -H -E -u "${g_user}" go get -u github.com/tomnomnom/httprobe
    unset GO111MODULE
    ln -s "${GO_PACKAGE_PATH}/bin/httprobe" /usr/bin/httprobe
}

install_amass() {
    export GO111MODULE=on
    sudo -H -E -u "${g_user}" go get -v github.com/OWASP/Amass/v3/...
    unset GO111MODULE
    ln -s "${GO_PACKAGE_PATH}/bin/amass" /usr/bin/amass
    git clone "https://github.com/OWASP/Amass" "${WORKING_DIR}/Amass"
    mkdir -p "${WORDLISTS_PATH}/amass"
    cp -r "${WORKING_DIR}/Amass/examples/wordlists/" "${WORDLISTS_PATH}"
    mv "${WORDLISTS_PATH}/wordlists" "${WORDLISTS_PATH}/amass"
    rm -rf "${WORKING_DIR}/Amass"
    mkdir -p ~/.config/amass
    sed "s|ALIENVAULT_API_KEY|${ALIENVAULT_API_KEY}|g" "${WORKING_DIR}/config-tools/config.ini" |
    sed "s|BINARYEDGE_API_KEY|${BINARYEDGE_API_KEY}|g" |
    sed "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" |
    sed "s|CENSYS_SECRET|${CENSYS_SECRET}|g" |
    sed "s|CLOUDFARE_API_KEY|${CLOUDFARE_API_KEY}|g" |
    sed "s|GITHUB_API_KEY|${GITHUB_API_KEY}|g" |
    sed "s|NETWORKSDB_API_KEY|${NETWORKSDB_API_KEY}|g" |
    sed "s|PASSIVETOTAL_API_KEY|${PASSIVETOTAL_API_KEY}|g" |
    sed "s|PASSIVETOTAL_USERNAME|${PASSIVETOTAL_USERNAME}|g" |
    sed "s|RECONDEV_API_KEY|${RECONDEV_API_KEY}|g" |
    sed "s|SECURITYTRAILS_API_KEY|${SECURITYTRAILS_API_KEY}|g" |
    sed "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" |
    sed "s|URLSCAN_API_KEY|${URLSCAN_API_KEY}|g" |
    sed "s|VIRUSTOTAL_API_KEY|${VIRUSTOTAL_API_KEY}|g" |
    sed "s|WHOISXMLAPI_API_KEY|${WHOISXMLAPI_API_KEY}|g" |
    sed "s|ZOOMEYE_USERNAME|${ZOOMEYE_USERNAME}|g" |
    sed "s|ZOOMEYE_PASSWORD|${ZOOMEYE_PASSWORD}|g" |
    sed "s|WORDLISTS_PATH|${WORDLISTS_PATH}|g" > ~/.config/amass/config.ini
    chown -R "${g_user}:${g_user}" ~/.config/amass
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

install_massdns() {
    git clone 'https://github.com/blechschmidt/massdns.git' "${WORKING_DIR}/massdns"
    cd "${WORKING_DIR}/massdns"
    make
    mkdir "${MASSDNS_PATH}"
    cp "${WORKING_DIR}/massdns/bin/massdns" "${MASSDNS_PATH}"
    cp -R "${WORKING_DIR}/massdns/lists" "${MASSDNS_PATH}"
    chown -R "${g_user}:${g_user}" "${MASSDNS_PATH}"
    ln -s "${MASSDNS_PATH}/massdns" /usr/bin/massdns
    cd -
    rm -rf "${WORKING_DIR}/massdns"
}

install_masscan() {
    git clone 'https://github.com/robertdavidgraham/masscan' "${WORKING_DIR}/masscan"
    cd "${WORKING_DIR}/masscan"
    make
    mkdir "${MASSCAN_PATH}"
    cp "${WORKING_DIR}/masscan/bin/masscan" "${MASSCAN_PATH}"
    chown -R "${g_user}:${g_user}" "${MASSCAN_PATH}"
    ln -s "${MASSCAN_PATH}/masscan" /usr/bin/masscan
    cd -
    rm -rf "${WORKING_DIR}/masscan"
}

install_dnmasscan() {
    git clone "https://github.com/rastating/dnmasscan.git" "${WORKING_DIR}/dnmasscan"
    mkdir "${DNMASSCAN_PATH}"
    cp "${WORKING_DIR}/dnmasscan/dnmasscan" "${DNMASSCAN_PATH}"
    chown -R "${g_user}:${g_user}" "${DNMASSCAN_PATH}"
    ln -s "${DNMASSCAN_PATH}/dnmasscan" /usr/bin/dnmasscan
    rm -rf "${WORKING_DIR}/dnmasscan"
}

install_nmap() {
    pacman -S --noconfirm nmap
}

install_medusa() {
    pacman -S --noconfirm medusa
}

install_brutespray() {
    git clone "https://github.com/x90skysn3k/brutespray.git" "${WORKING_DIR}/brutespray"
    mkdir "${BRUTESPRAY_PATH}"
    mkdir -p "${WORDLISTS_PATH}/brutespray"
    pip install -r "${WORKING_DIR}/brutespray/requirements.txt"
    cp "${WORKING_DIR}/brutespray/brutespray.py" "${BRUTESPRAY_PATH}"
    chown -R "${g_user}:${g_user}" "${BRUTESPRAY_PATH}"
    ln -s "${BRUTESPRAY_PATH}/brutespray.py" /usr/bin/brutespray
    cp -R "${WORKING_DIR}/brutespray/wordlist/" "${WORDLISTS_PATH}/brutespray/"
    rm -rf "${WORKING_DIR}/brutespray"
}

install_favfreak() {
    git clone "https://github.com/devanshbatham/FavFreak" "${WORKING_DIR}/FavFreak"
    mkdir "${FAVFREAK_PATH}"
    pip install -r "${WORKING_DIR}/FavFreak/requirements.txt"
    cp "${WORKING_DIR}/FavFreak/favfreak.py" "${FAVFREAK_PATH}"
    chmod +x "${FAVFREAK_PATH}/favfreak.py"
    chown -R "${g_user}:${g_user}" "${FAVFREAK_PATH}"
    ln -s "${FAVFREAK_PATH}/favfreak.py" /usr/bin/favfreak
    rm -rf "${WORKING_DIR}/FavFreak"
}

install_subover() {
    sudo -H -E -u "${g_user}" go get "github.com/Ice3man543/SubOver"
    ln -s "${GO_PACKAGE_PATH}/bin/SubOver" /usr/bin/subover
}

install_ffuf() {
    sudo -H -E -u "${g_user}" go get "github.com/ffuf/ffuf"
    ln -s "${GO_PACKAGE_PATH}/bin/ffuf" /usr/bin/ffuf
}

install_sqlmap() {
    pacman -S --noconfirm sqlmap
}

fix_wordlists_owner() {
    chown -R "${g_user}:${g_user}" "${WORDLISTS_PATH}"
}

install_all() {
    #install_eyewitness
    #install_assetfinder
    install_asnlookup
    install_metabigor
    install_domlink
    install_getrelationship
    install_gospider
    install_hakrawler
    install_subdomainizer
    install_subscraper
    install_shosubgo
    install_github_subdomains
    install_github_search
    install_httprobe
    install_amass
    install_subfinder
    install_massdns
    install_masscan
    install_dnmasscan
    install_nmap
    install_medusa
    install_brutespray
    install_favfreak
    install_subover
    install_ffuf
    install_sqlmap
    fix_wordlists_owner
}

###################### UNINSTALL ######################

remove_metabigor() {
    rm -rf /usr/bin/metabigor
}

remove_asnlookup() {
    rm -rf "${ASNLOOKUP_PATH}"
    rm -rf /usr/bin/asnlookup
}

remove_domlink() {
    rm -rf "${DOMLINK_PATH}"
    rm -rf /usr/bin/domlink
}

remove_getrelationship() {
    rm -rf "${GETRELATIONSHIP_PATH}"
    rm -rf /usr/bin/getrelationship
}

remove_gospider() {
    rm -rf /usr/bin/gospider
}

remove_hakrawler() {
    rm -rf /usr/bin/hakrawler
}

remove_subdomainizer() {
    rm -rf "${SUBDOMAINIZER_PATH}"
    rm -rf /usr/bin/subdomainizer
}

remove_subscraper() {
    rm -rf "${SUBSCRAPER_PATH}"
    rm -rf /usr/bin/subscraper
}

remove_shosubgo() {
    rm -rf "${SHOSUBGO_PATH}"
    rm -rf /usr/bin/shosubgo
}

remove_github_subdomains() {
    rm -rf /usr/bin/github-subdomains
}

remove_github_search() {
    rm -rf "${GITHUB_SEARCH_PATH}"
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
    rm -rf "${EYEWITNESS_PATH}"
    rm -rf /usr/bin/eyewitness
    # eyewitness has a custom installer that installs
    # a lot of dependencies; I cannot delete those manually
    # because a lot of them may be required by other software
}

remove_subfinder() {
    rm -rf /usr/bin/subfinder
}

remove_massdns() {
    rm -rf "${MASSDNS_PATH}"
    rm -rf /usr/bin/massdns
}

remove_masscan() {
    rm -rf "${MASSCAN_PATH}"
    rm -rf /usb/bin/masscan
}

remove_dnmasscan() {
    rm -rf "${DNMASSCAN_PATH}"
    rm -rf /usr/bin/dnmasscan
}

remove_nmap() {
    pacman -Rs --noconfirm nmap
}

remove_medusa() {
    pacman -Rs --noconfirm medusa
}

remove_brutespray() {
    rm -rf "${BRUTESPRAY_PATH}"
    rm -rf /usr/bin/brutespray
}

remove_favfreak() {
    rm -rf "${FAVFREAK_PATH}"
    rm -rf /usr/bin/favfreak
}

remove_subover() {
    rm -rf /usr/bin/subover
}

remove_ffuf() {
    rm -rf /usr/bin/ffuf
}

remove_sqlmap() {
    pacman -Rs --noconfirm sqlmap
}

remove_wordlists() {
    rm -rf "${WORDLISTS_PATH}"
}

remove_all() {
    #remove_eyewitness
    #remove_assetfinder
    remove_asnlookup
    remove_metabigor
    remove_domlink
    remove_getrelationship
    remove_gospider
    remove_hakrawler
    remove_subdomainizer
    remove_subscraper
    remove_shosubgo
    remove_github_subdomains
    remove_github_search
    remove_httprobe
    remove_amass
    remove_subfinder
    remove_massdns
    remove_masscan
    remove_dnmasscan
    remove_nmap
    remove_medusa
    remove_brutespray
    remove_favfreak
    remove_subover
    remove_ffuf
    remove_sqlmap
    remove_wordlists
}

#######################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/config-files/install_paths.sh"

export GOPATH="${PATH_GOLANG}"
GO_PACKAGE_PATH="${PATH_GOLANG}"

EYEWITNESS_PATH='/opt/eyewitness'
ASNLOOKUP_PATH='/opt/asnlookup'
DOMLINK_PATH='/opt/domlink'
GETRELATIONSHIP_PATH='/opt/getrelationship'
SUBDOMAINIZER_PATH='/opt/subdomainizer'
SUBSCRAPER_PATH='/opt/subscraper'
SHOSUBGO_PATH='/opt/shosubgo'
GITHUB_SEARCH_PATH='/opt/github-search'
MASSDNS_PATH='/opt/massdns'
MASSCAN_PATH='/opt/masscan'
DNMASSCAN_PATH='/opt/dnmasscan'
BRUTESPRAY_PATH='/opt/brutespray'
FAVFREAK_PATH='/opt/favfreak'
WORDLISTS_PATH='/opt/wordlists'

ALIENVAULT_API_KEY=${ALIENVAULT_API_KEY:-'key-not-provided'}
BINARYEDGE_API_KEY=${BINARYEDGE_API_KEY:-'key-not-provided'}
CENSYS_API_KEY=${CENSYS_API_KEY:-'key-not-provided'}
CENSYS_SECRET=${CENSYS_SECRET:-'key-not-provided'}
CLOUDFARE_API_KEY=${CLOUDFARE_API_KEY:-'key-not-provided'}
GITHUB_API_KEY=${GITHUB_API_KEY:-'key-not-provided'}
NETWORKSDB_API_KEY=${NETWORKSDB_API_KEY:-'key-not-provided'}
PASSIVETOTAL_API_KEY=${PASSIVETOTAL_API_KEY:-'key-not-provided'}
PASSIVETOTAL_USERNAME=${PASSIVETOTAL_USERNAME:-'key-not-provided'}
RECONDEV_API_KEY=${RECONDEV_API_KEY:-'key-not-provided'}
SECURITYTRAILS_API_KEY=${SECURITYTRAILS_API_KEY:-'key-not-provided'}
SHODAN_API_KEY=${SHODAN_API_KEY:-'key-not-provided'}
URLSCAN_API_KEY=${URLSCAN_API_KEY:-'key-not-provided'}
VIRUSTOTAL_API_KEY=${VIRUSTOTAL_API_KEY:-'key-not-provided'}
WHOISXMLAPI_API_KEY=${WHOISXMLAPI_API_KEY:-'key-not-provided'}
ZOOMEYE_USERNAME=${ZOOMEYE_USERNAME:-'key-not-provided'}
ZOOMEYE_PASSWORD=${ZOOMEYE_PASSWORD:-'key-not-provided'}

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
