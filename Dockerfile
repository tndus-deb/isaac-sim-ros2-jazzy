FROM nvcr.io/nvidia/isaac-sim:5.1.0

USER root
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 기본 패키지 및 locale 설정
RUN apt-get update && apt-get install -y \
    locales \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    sudo \
    nano \
    vim \
    git \
    python3-pip \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# ROS2 Jazzy apt 저장소 설정
RUN add-apt-repository universe -y \
    && apt-get update \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
       -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
       > /etc/apt/sources.list.d/ros2.list

# ROS2 Jazzy 설치
RUN apt-get update && apt-get install -y \
    ros-jazzy-desktop \
    ros-dev-tools \
    python3-rosdep \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# rosdep 초기화
RUN rosdep init || true && rosdep update || true

# ROS2 환경 자동 source
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc

# ROS2 기본 환경변수
ENV ROS_DISTRO=jazzy
ENV ROS_VERSION=2
ENV ROS_PYTHON_VERSION=3

# 기본 Domain ID
# 실제 실행 시 docker run에서 -e ROS_DOMAIN_ID=번호 로 팀원별 변경
ENV ROS_DOMAIN_ID=0

# 컨테이너 시작 스크립트 복사
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Isaac Sim 컨테이너 내부 기본 경로
WORKDIR /isaac-sim

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
