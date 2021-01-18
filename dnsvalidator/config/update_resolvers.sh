#!/bin/sh

main() {
    dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 10 -o "PATH_RESOLVERS/nameservers.new.txt"
    mv "PATH_RESOLVERS/nameservers.new.txt" "PATH_RESOLVERS/nameservers.txt"
}

main "${@}"
