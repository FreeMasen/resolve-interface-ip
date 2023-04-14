FROM ubuntu:20.04 as builder
RUN apt-get -y update && apt-get install -y clang
WORKDIR /usr/src/resolve-ip
COPY . .
RUN clang ./main.c -DIFACE_IP_BY_ITERS -O3 -o ./iters \
 && clang ./main.c -DIFACE_IP_BY_IOCTL -O3 -o ./ioctl

FROM ubuntu:20.04
RUN apt-get -y update && apt-get install -y \
  net-tools \
  wget \
 && wget https://github.com/sharkdp/hyperfine/releases/download/v1.16.1/hyperfine_1.16.1_amd64.deb \
 && dpkg -i hyperfine_1.16.1_amd64.deb
COPY --from=builder /usr/src/resolve-ip/iters /usr/local/bin/iters
COPY --from=builder /usr/src/resolve-ip/ioctl /usr/local/bin/ioctl
WORKDIR /usr/src/results
CMD ["hyperfine", "--export-markdown=README.md", "-N", "-r=1000000", "iters eth0", "ioctl eth0"]
