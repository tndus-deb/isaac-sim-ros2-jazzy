#!/bin/bash

source /opt/ros/jazzy/setup.bash

echo "======================================"
echo " Isaac Sim 5.1.0 + ROS2 Jazzy"
echo " ROS_DISTRO=$ROS_DISTRO"
echo " ROS_DOMAIN_ID=$ROS_DOMAIN_ID"
echo "======================================"

exec "$@"
