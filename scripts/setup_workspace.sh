#!/bin/bash

# ROS2工作空间设置脚本
# 该脚本用于在容器中创建和设置ROS2工作空间

echo "设置ROS2工作空间..."

# 创建工作空间目录
mkdir -p /home/skyris/ros2_ws/src
cd /home/skyris/ros2_ws

echo "ROS2工作空间已创建: /home/skyris/ros2_ws"
echo ""
echo "使用说明："
echo "1. 进入工作空间: cd /home/skyris/ros2_ws"
echo "2. 克隆源码仓库到src目录: git clone <your_repo_url> src/"
echo "3. 安装依赖: rosdep install -i --from-path src --rosdistro humble -y"
echo "4. 编译工作空间: colcon build"
echo "5. 设置环境: source install/setup.bash"
echo "6. 运行ROS2节点"
echo ""
echo "或者使用volume挂载方式将主机上的源码目录挂载到容器的src目录"