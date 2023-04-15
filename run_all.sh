#! /bin/bash

INTERFACE_NAME="$(ip -o -4 route show to default | awk '{print $5}')"
mkdir -p ./target

clang ./main.c -DIFACE_IP_BY_ITERS -O3 -o ./target/iters \
  && clang ./main.c -DIFACE_IP_BY_IOCTL -O3 -o ./target/ioctl \
  && clang -S -emit-llvm ./main.c -DIFACE_IP_BY_IOCTL -O3 -o ./results/ioctl.ll \
  && clang -S -emit-llvm ./main.c -DIFACE_IP_BY_ITERS -O3 -o ./results/iters.ll \
  && hyperfine --export-markdown=./results/hyperfine.md -N "./target/iters $INTERFACE_NAME" "./target/ioctl $INTERFACE_NAME" \
  && strace ./target/iters $INTERFACE_NAME 2> ./results/by_iters_strace.log \
  && strace ./target/ioctl $INTERFACE_NAME 2> ./results/by_ioctl_strace.log
