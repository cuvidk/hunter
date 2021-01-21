install() {(
    set -e
    local version='2.2.0'
    local archive_name="nuclei_${version}_linux_amd64.tar.gz"
    mkdir -p "${PATH_NUCLEI}"
    cd "${PATH_NUCLEI}"
    wget "https://github.com/projectdiscovery/nuclei/releases/download/v${version}/${archive_name}"
    tar -xzvf "${archive_name}"
    rm -rf "${archive_name}"
    echo '#!/bin/sh' >"${PATH_NUCLEI}/nuclei.sh"
    echo "${PATH_NUCLEI}/nuclei" '${@}' "-update-directory ${PATH_NUCLEI}" >>"${PATH_NUCLEI}/nuclei.sh"
    chmod +x "${PATH_NUCLEI}/nuclei.sh"
    ln -s "${PATH_NUCLEI}/nuclei.sh" /usr/bin/nuclei
    /usr/bin/nuclei -update-templates
)}

uninstall() {
    rm -rf "${PATH_NUCLEI}"
    rm -rf /usr/bin/nuclei
}
