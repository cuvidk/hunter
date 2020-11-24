WHOXY_API_KEY=${WHOXY_API_KEY:-WHOXY_API_KEY}

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_DOMLINK_CONFIG})"
    sed "s|WHOXY_API_KEY|${WHOXY_API_KEY}|g" "${MAKE_CONFIG_SCRIPT_DIR}/domlink/config/domLink.cfg" >"${PATH_DOMLINK_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_DOMLINK_CONFIG}"
}
