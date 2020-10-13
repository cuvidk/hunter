FROM archlinux:latest
WORKDIR /root
RUN pacman -Sy
COPY . /root/haxing-tools
RUN ./haxing-tools/prerequisites.sh
RUN ./haxing-tools/tools.sh install
CMD /usr/bin/sh -l
