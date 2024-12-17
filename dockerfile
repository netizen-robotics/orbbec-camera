FROM public.ecr.aws/y8l1o1z1/ros2-jazzy:latest

USER root

# Install library for Orbbec sdk 
RUN apt-get update
RUN apt-get install udev libgflags-dev nlohmann-json3-dev  \
    ros-${ROS_DISTRO}-image-transport ros-${ROS_DISTRO}-image-publisher ros-${ROS_DISTRO}-camera-info-manager \
    ros-${ROS_DISTRO}-diagnostic-updater ros-${ROS_DISTRO}-diagnostic-msgs ros-${ROS_DISTRO}-statistics-msgs \
    ros-${ROS_DISTRO}-backward-ros libdw-dev -y

# Using robot workspace
WORKDIR /home/user/robot_ws/src

# Clone Orbbec ROS2 SDK
RUN git clone -b v2-main https://github.com/orbbec/OrbbecSDK_ROS2.git

WORKDIR /home/user/robot_ws
RUN rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build

# Setup Orbbec related rules
WORKDIR  /home/user/robot_ws/src/OrbbecSDK_ROS2/orbbec_camera/scripts
RUN bash install_udev_rules.sh

# Setup entrypoint
COPY --chown=user:netizen_robotics ./script/entrypoint.sh  /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

# Switch to user
USER user
WORKDIR /home/user
ENTRYPOINT ["/home/user/entrypoint.sh"]