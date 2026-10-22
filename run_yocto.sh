#!/bin/bash


chmod +x ./setup_build.sh

# Run the container and immediately execute the inner setup script
# docker run -it --rm -v /home/phlagg/projects/yocto:/home/yoctouser/yocto yocto-rpi3-builder /bin/bash ./setup_build.sh
# docker run -it --rm   --security-opt seccomp=unconfined --cap-add=SYS_PTRACE -v "$(pwd)":/home/yoctouser/yocto yocto-rpi3-builder /bin/bash ./setup_build.sh

LOCAL_API_MANAGER_PATH="/home/phlagg/Projects/api-manager"

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
  --annotation=run.oci.keep_original_groups=1 \
  -v $(pwd):/workdir \
  -v "$LOCAL_API_MANAGER_PATH:/workdir/local-repos/api-manager" \
  crops/poky:ubuntu-22.04 \
  --id $(id -u):$(id -g) \
  --workdir=/workdir \
  /bin/bash -c "./setup_build.sh"
