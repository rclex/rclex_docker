### FIXME according to the target version
# base image, ARG is overridable by --build-arg
ARG BASE_IMAGE=hexpm/elixir:1.15.5-erlang-26.0.2-ubuntu-jammy-20230126
FROM $BASE_IMAGE
# Set Ubuntu Codename ENV, ARG is overridable by --build-arg
ARG UBUNTU_CODENAME
ENV UBUNTU_CODENAME=${UBUNTU_CODENAME:-jammy}
# Set ROS_DISTRO ENV, ARG is overridable by --build-arg
ARG ROS_DISTRO
ENV ROS_DISTRO=${ROS_DISTRO:-humble}

# force error about debconf
ENV DEBIAN_FRONTEND noninteractive

# update sources list
## inotify-tools: for mix test.watch
## astyle: to format C code in NIFs
RUN apt-get clean && \
  apt-get update && \
  apt-get install -y git sudo build-essential \
  inotify-tools \
  astyle \
  && rm -rf /var/lib/apt/lists/*

### install ROS START
### https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

# Set locale
RUN apt-get update && apt-get -y install locales && \
  locale-gen en_US en_US.UTF-8 && \
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
  export LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

# Setup Sources
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release \
  && rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Upgrade before installing ROS 2 packages
# WHY: refer to "Warning" in https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html#install-ros-2-packages
RUN apt-get update \
  && apt-get upgrade \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install ROS 2 packages
RUN apt-get update && \
  apt-get install -y ros-${ROS_DISTRO}-ros-base \
  && rm -rf /var/lib/apt/lists/*

# Install colcon-core
RUN apt-get update && \
  apt-get install -y python3-colcon-common-extensions \
  && rm -rf /var/lib/apt/lists/*

# Setup ROS environment in shell
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.sh' >> ~/.bashrc

### install ROS END

# cleanup
RUN apt-get -qy autoremove

# install hex and rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# check version
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && env | grep ROS && \
  mix hex.info

COPY docker-entrypoint.sh /root/
RUN chmod +x /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD ["/bin/bash"]
