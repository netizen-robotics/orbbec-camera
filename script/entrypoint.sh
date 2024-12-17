#!/bin/bash
set -e

source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/home/user/robot_ws/install/setup.bash"

exec "$@"
