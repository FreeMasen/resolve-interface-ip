# Resolve Interace Ip

Benchmarking the difference between `getifaddrs` and `ioctl(SIOCGIFADDR)` for 
looking up an interface ip address by name.

## Results

- straces
  - [by ioctl](./results/by_ioctl_strace.log)
  - [by iters](./results/by_iters_strace.log)
- llvm ir
  - [by ioctl](./results/ioctl.ll)
  - [by iters](./results/iters.ll)
- [hyperfine results](./results/hyperfine.md)

## Usage

To run this in a docker container which will reduce the total number of devices
returned by `getifaddrs` to be just `lo` and `eth0` you can run the following
docker commands.

```sh
git clone https://github.com/FreeMasen/resolve-interface-ip
cd ./resolve-interface-ip
docker build -t resolve-interface-ip .
docker run -v $PWD:/usr/src/resolve-ip resolve-interface-ip
```

This will overwrite the contents of ./results.

---

To run this locally you would need to have a few things installed that would typically
be available on a ubuntu:20.04 development machine.
  
- [`clang`](https://clang.llvm.org/get_started.html)
- [`hyperfine`](https://github.com/sharkdp/hyperfine)
- [`ip`](https://stackoverflow.com/questions/51834978/ip-command-is-missing-from-ubuntu-docker-image)
- [`strace`](https://wiki.ubuntu.com/Strace)

Once those is in place, simply run `./run_all.sh`
