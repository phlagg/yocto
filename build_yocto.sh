
docker build --build-arg host_uid=$(id -u) --build-arg host_gid=$(id -g) -t yocto-rpi3-builder .
