install() {(
    set -e
    git clone "https://github.com/vortexau/dnsvalidator.git" src-dnsvalidator
    cd src-dnsvalidator
    mkdir -p "${PATH_DNSVALIDATOR}"
    python3 setup.py install --record "${PATH_DNSVALIDATOR}/uninstall.txt"
)}

post_install() {
    rm -rf src-dnsvalidator
}

uninstall() {(
    set -e
    [ -e "${PATH_DNSVALIDATOR}/uninstall.txt" ] &&
        cat "${PATH_DNSVALIDATOR}/uninstall.txt" | xargs -I{} rm -rf {}
    rm -rf "${PATH_DNSVALIDATOR}"
)}
