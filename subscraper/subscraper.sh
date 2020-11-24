pre_install() {(
    set -e
    pacman -S --noconfirm python-pip
    pip install ipparser
    git clone "https://github.com/m8r0wn/subscraper" "${MAKE_SCRIPT_DIR}/Subscraper"
    exit 0
)}

install() {(
    set -e
    cd "${MAKE_SCRIPT_DIR}/Subscraper"
    python3 setup.py install
    mkdir -p "${PATH_SUBSCRAPER}"
    mv /usr/bin/subscraper "${PATH_SUBSCRAPER}/subscraper"
    cp "${MAKE_SCRIPT_DIR}/subscraper/config/subscraper.sh" "${PATH_SUBSCRAPER}"
    chmod +x "${PATH_SUBSCRAPER}/subscraper.sh"
    ln -s "${PATH_SUBSCRAPER}/subscraper.sh" /usr/bin/subscraper
    exit 0
)}

post_install() {(
    set -e
    rm -rf "${MAKE_SCRIPT_DIR}/Subscraper"
    "${MAKE_SCRIPT_DIR}/subscraper/subscraper_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/subscraper/subscraper_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/subscraper
    rm -rf "${PATH_SUBSCRAPER}"
    exit 0
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/subscraper/subscraper_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/subscraper/subscraper_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    pacman -Rs --noconfirm python-pip
    exit 0
)}
