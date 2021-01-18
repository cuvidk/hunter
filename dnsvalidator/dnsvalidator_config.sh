install() {(
    set -e
    sed "s|PATH_RESOLVERS|${PATH_RESOLVERS}|g" "${MAKE_CONFIG_SCRIPT_DIR}/dnsvalidator/config/update_resolvers.sh" >"${PATH_DNSVALIDATOR}/update_resolvers.sh"
    chmod +x "${PATH_DNSVALIDATOR}/update_resolvers.sh"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/dnsvalidator/config/nameservers.txt" "${PATH_DNSVALIDATOR}"
)}

uninstall() {
    rm -rf "${PATH_DNSVALIDATOR}/update_resolvers.sh"
    rm -rf "${PATH_DNSVALIDATOR}/nameservers.txt"
}
