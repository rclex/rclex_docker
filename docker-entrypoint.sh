#!/bin/bash

set -e

#shellcheck disable=SC1090
source "/opt/ros/${ROS_DISTRO}/setup.bash"

exec "$@"
