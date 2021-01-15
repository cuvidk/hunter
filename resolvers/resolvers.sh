install() {(
    set -e
    mkdir -p "${PATH_RESOLVERS}"
    cd "${PATH_RESOLVERS}"
    if [ ! -e "${PATH_RESOLVERS}/nameservers.txt" ]; then
        wget 'https://public-dns.info/nameservers.txt'
    fi
)}

uninstall() {
    rm -rf "${PATH_RESOLVERS}"
}
