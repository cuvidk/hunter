install() {
    git clone "https://github.com/gwen001/github-search.git" "${PATH_GITHUB_SEARCH}"
}

uninstall() {
    rm -rf "${PATH_GITHUB_SEARCH}"
}
