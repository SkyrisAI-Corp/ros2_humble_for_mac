# Use the official ROS image as the base image
FROM ros:humble-ros-core-jammy

# 创建skyris用户
RUN useradd -m -s /bin/bash skyris && \
    echo "skyris:skyris" | chpasswd && \
    usermod -aG sudo skyris

# 在root用户下执行需要管理员权限的操作
USER root
WORKDIR /home/skyris/ros/

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
COPY . /home/skyris/ros/
ADD sources.list /etc/apt/ 

# Set shell for running commands
SHELL ["/bin/bash", "-c"]

# 更新并添加ROS2的GPG密钥
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
RUN apt-key adv --refresh-keys

# 添加ROS2清华源（忽略GPG检查）
RUN echo "deb [trusted=yes] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu jammy main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# install rosdepc
RUN pip install rosdepc \
  rosdepc init \
  rosdepc update
  
# bootstrap rosdep
# RUN rosdep init && \
#   rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://gitee.com/zhenshenglee/colcon-mixin-repository/raw/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://gitee.com/aviana-zheng/colcon-metadata-repository/raw/master/index.yaml && \
    colcon metadata update

# RUN colcon mixin add default \
#       https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
#     colcon mixin update && \
#     colcon metadata add default \
#       https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
#     colcon metadata update

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

# Copy workspace setup script
COPY scripts/setup_workspace.sh /home/skyris/setup_workspace.sh
RUN chmod +x /home/skyris/setup_workspace.sh

# 设置用户登录后的工作目录
RUN echo "cd /home/skyris/ros" >> /home/skyris/.bashrc

# 切换回skyris用户
USER skyris

# Set the entrypoint to source ROS setup.bash and run a bash shell
CMD ["/bin/bash"]