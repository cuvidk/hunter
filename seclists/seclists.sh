install() {(
    set -e
    mkdir -p "$(dirname "${PATH_SECLISTS_WORDLISTS}")"
    git clone https://github.com/danielmiessler/SecLists.git "${PATH_SECLISTS_WORDLISTS}"
)}

uninstall() {(
    set -e
    rm -rf "${PATH_SECLISTS_WORDLISTS}"
)}
