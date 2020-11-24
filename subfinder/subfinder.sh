install() {(
    set -e
    local version="2.4.5"
    mkdir -p "${MAKE_SCRIPT_DIR}/Subfinder"
    cd "${MAKE_SCRIPT_DIR}/Subfinder"
    wget "https://github.com/projectdiscovery/subfinder/releases/download/v${version}/subfinder_${version}_linux_amd64.tar.gz"
    tar -xzvf "subfinder_${version}_linux_amd64.tar.gz"
    mkdir -p "${PATH_SUBFINDER}"
    mv subfinder "${PATH_SUBFINDER}"
    ln -s "${PATH_SUBFINDER}/subfinder" /usr/bin/subfinder
    cd -
    rm -rf "${MAKE_SCRIPT_DIR}/Subfinder"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subfinder
    rm -rf "${PATH_SUBFINDER}"
    exit 0
)}
