install() {(
    set -e
    mkdir -p "$(dirname "${PATH_KALILISTS_WORDLISTS}")"
    git clone "https://github.com/3ndG4me/KaliLists.git" "${PATH_KALILISTS_WORDLISTS}"
)}

uninstall() {(
    set -e
    rm -rf "${PATH_KALILISTS_WORDLISTS}"
)}
