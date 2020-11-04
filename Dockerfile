FROM archlinux:latest
ARG CENSYS_API_KEY
ARG CENSYS_SECRET
ARG SHODAN_API_KEY
WORKDIR /root
RUN pacman -Syu --noconfirm
COPY . /root/hunter
RUN ./hunter/prerequisites.sh --verbose
RUN ./hunter/tools.sh install
CMD /usr/bin/zsh -l
