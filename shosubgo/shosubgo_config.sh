SHODAN_API_KEY=${SHODAN_API_KEY:-'SHODAN_API_KEY'}

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SHOSUBGO_CONFIG})"
    if [ -f "${PATH_SHOSUBGO_CONFIG}" ]; then
        sed -i "s|PATH_SHOSUBGO|${PATH_SHOSUBGO}|g" "${PATH_SHOSUBGO_CONFIG}"
        sed -i "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" "${PATH_SHOSUBGO_CONFIG}"
    else
        sed "s|PATH_SHOSUBGO|${PATH_SHOSUBGO}|g" "${MAKE_CONFIG_SCRIPT_DIR}/shosubgo/config/shosubgo.sh" |
        sed "s|SHODAN_API_KEY|${SHODAN_API_KEY}|g" >"${PATH_SHOSUBGO_CONFIG}"
    fi
    exit 0
)}

uninstall() {
    rm -rf "${PATH_SHOSUBGO_CONFIG}"
}
