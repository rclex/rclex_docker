### FIXME according to the target version
# base image
FROM hexpm/elixir:1.12.3-erlang-24.1.5-ubuntu-focal-20210325
# Set Ubuntu Codename
ENV UBUNTU_CODENAME focal
# Set ROS_DISTRO environment
ENV ROS_DISTRO foxy

# force error about debconf
ENV DEBIAN_FRONTEND noninteractive

# update sources list
RUN apt-get clean
RUN apt-get update

# install additonal packages
RUN apt-get install -y git sudo build-essential

# install AStyle to format C code (NIFs)
RUN apt-get install -y astyle

### install ROS START
### https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html

# Set locale
RUN apt update && apt -y install locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Setup Sources
RUN apt update && apt install -y curl gnupg2 lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 packages
RUN apt update
RUN apt install -y ros-${ROS_DISTRO}-ros-base

# Install ROS 2 packages
RUN apt install -y python3-colcon-common-extensions

# Setup ROS environment in shell
RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.sh' >> ~/.bashrc

### install ROS END

# cleanup
RUN apt-get -qy autoremove

# install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# check version
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && env | grep ROS
RUN mix hex.info

