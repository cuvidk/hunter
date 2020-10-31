FROM archlinux:latest
ARG CENSYS_API_KEY
ARG CENSYS_SECRET
ARG SHODAN_API_KEY
WORKDIR /root
RUN pacman -Syu --noconfirm
COPY . /root/haxing-tools
RUN ./haxing-tools/prerequisites.sh --verbose
RUN ./haxing-tools/tools.sh install
CMD /usr/bin/zsh -l
