FROM ubuntu:20.04
RUN apt-get -y update && apt-get install -y \
  clang \
  net-tools \
  iproute2 \
  strace \
  wget \
  && wget https://github.com/sharkdp/hyperfine/releases/download/v1.16.1/hyperfine_1.16.1_amd64.deb \
  && dpkg -i hyperfine_1.16.1_amd64.deb
WORKDIR /usr/src/resolve-ip

CMD "./run_all.sh" 
