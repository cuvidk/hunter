install() {(
    set -e
    git clone "https://github.com/vortexau/dnsvalidator.git" src-dnsvalidator
    cd src-dnsvalidator
    mkdir -p "${PATH_DNSVALIDATOR}"
    python3 setup.py install --record "${PATH_DNSVALIDATOR}/uninstall.txt"

    #TODO: to lazy to move this to dnsvalidator_config.sh for now
    sed "s|PATH_RESOLVERS|${PATH_RESOLVERS}|g" "${MAKE_SCRIPT_DIR}/dnsvalidator/config/update_resolvers.sh" >"${PATH_DNSVALIDATOR}/update_resolvers.sh"
    chmod +x "${PATH_DNSVALIDATOR}/update_resolvers.sh"
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
