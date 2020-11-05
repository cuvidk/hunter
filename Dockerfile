FROM archlinux:latest
ARG ALIENVAULT_API_KEY
ARG BINARYEDGE_API_KEY
ARG CENSYS_API_KEY
ARG CENSYS_SECRET
ARG CLOUDFARE_API_KEY
ARG GITHUB_API_KEY
ARG NETWORKSDB_API_KEY
ARG PASSIVETOTAL_API_KEY
ARG PASSIVETOTAL_USERNAME
ARG RECONDEV_API_KEY
ARG SECURITYTRAILS_API_KEY
ARG SHODAN_API_KEY
ARG URLSCAN_API_KEY
ARG VIRUSTOTAL_API_KEY
ARG WHOISXMLAPI_API_KEY
ARG ZOOMEYE_USERNAME
ARG ZOOMEYE_PASSWORD
WORKDIR /root
RUN pacman -Syu --noconfirm
COPY . /root/hunter
RUN ./hunter/prerequisites.sh --verbose
RUN ./hunter/tools.sh install
CMD /usr/bin/zsh -l
