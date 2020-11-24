install() {(
    set -e
    git clone 'https://github.com/cuvidk/EyeWitness.git' "${PATH_EYEWITNESS}"
    cd "${PATH_EYEWITNESS}"
    git checkout cuvidk-fork
    sh "${PATH_EYEWITNESS}/Python/setup/setup.sh"
    ln -s "${PATH_EYEWITNESS}/Python/EyeWitness.py" /usr/bin/eyewitness
    exit 0
)}

uninstall() {(
    set -e
    rm -rf /usr/bin/eyewitness
    rm -rf "${PATH_EYEWITNESS}"
    exit 0
)}
