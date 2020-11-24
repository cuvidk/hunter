export CENSYS_API_KEY="${CENSYS_API_KEY:-CENSYS_API_KEY}"
export CENSYS_SECRET="${CENSYS_SECRET:-CENSYS_SECRET}"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SUBSCRAPER_CONFIG})"
    if [ -f "${PATH_SUBSCRAPER_CONFIG}" ]; then
        sed -i "s|PATH_SUBSCRAPER|${PATH_SUBSCRAPER}|g" "${PATH_SUBSCRAPER_CONFIG}"
        sed -i "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" "${PATH_SUBSCRAPER_CONFIG}"
        sed -i "s|CENSYS_SECRET|${CENSYS_SECRET}|g" "${PATH_SUBSCRAPER_CONFIG}"
    else
        sed "s|PATH_SUBSCRAPER|${PATH_SUBSCRAPER}|g" "${MAKE_CONFIG_SCRIPT_DIR}/subscraper/config/subscraper.sh" |
        sed "s|CENSYS_API_KEY|${CENSYS_API_KEY}|g" |
        sed "s|CENSYS_SECRET|${CENSYS_SECRET}|g" >"${PATH_SUBSCRAPER_CONFIG}"
    fi
    exit 0
)}

uninstall() {
    rm -rf "${PATH_SUBSCRAPER_CONFIG}"
}
