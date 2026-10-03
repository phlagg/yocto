FROM crops/poky:ubuntu-22.04


# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install all essential Yocto host dependencies
# RUN apt-get update && apt-get install -y \
#     gawk wget git diffstat unzip texinfo gcc \
#     build-essential chrpath socat cpio python3 python3-pip \
#     python3-pexpect xz-utils debianutils iputils-ping \
#     python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
#     pylint xterm rsync curl locales sudo \
#     file liblz4-tool zstd \
#     && rm -rf /var/lib/apt/lists/*

# Set the locale to en_US.UTF-8 to prevent Yocto build failures
# RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8

# Configure the non-root user variables
ENV USER_NAME=yoctouser
ARG host_uid=1001
ARG host_gid=1001
#
# # Create the group and user matching your host machine exactly
RUN groupadd -g $host_gid $USER_NAME && \
    useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME
#
# # Grant passwordless sudo access to your custom user
# RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} \
#     && chmod 0440 /etc/sudoers.d/${USER_NAME}

# Set the active user and default workspace
USER $USER_NAME
WORKDIR /home/yoctouser/yocto
