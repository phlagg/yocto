#!/bin/bash


chmod +x ./setup_build.sh

# Run the container and immediately execute the inner setup script
# docker run -it --rm -v /home/phlagg/projects/yocto:/home/yoctouser/yocto yocto-rpi3-builder /bin/bash ./setup_build.sh
# docker run -it --rm   --security-opt seccomp=unconfined --cap-add=SYS_PTRACE -v "$(pwd)":/home/yoctouser/yocto yocto-rpi3-builder /bin/bash ./setup_build.sh

# docker run -it --rm \
#   --security-opt seccomp=unconfined \
#   --cap-add=SYS_PTRACE \
#   -v "$(pwd)":/home/yoctouser/yocto \
#   --workdir /home/yoctouser/yocto \
#   yocto-rpi3-builder \
#   /bin/bash -c "./setup_build.sh"

docker run --rm -it \
  --privileged \
  --security-opt seccomp=unconfined \
  -v $(pwd):/workdir \
  crops/poky:ubuntu-22.04 \
  --id $(id -u):$(id -g) \
  --workdir=/workdir \
  /bin/bash -c "./setup_build.sh"
