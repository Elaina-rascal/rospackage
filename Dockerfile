FROM osrf/ros:noetic-desktop-full

# 定义用户和用户组
ARG USERNAME=Elaina
ARG USER_UID=1000
ARG USER_GID=$USER_UID
#安装必要软件
RUN apt-get update \
    && apt-get install -y  net-tools nautilus bash-completion gdb  
# 创建用户组和用户
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # 配置环境变量
    && echo "$USERNAME:'" | chpasswd \
    # 允许用户使用 sudo
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo 'source /opt/ros/noetic/setup.bash' >> /home/$USERNAME/.bashrc \
    # 使新用户的 `.bashrc` 文件生效
    && chown $USERNAME:$USERNAME /home/$USERNAME/.bashrc

#添加雷达驱动并设置雷达驱动环境变量 
USER $USERNAME
WORKDIR /home/$USERNAME
# RUN sudo -u $USERNAME mkdir ./packages  && cd ./packages && git clone https://github.com/Livox-SDK/Livox-SDK2.git \
# && cd Livox-SDK2 && mkdir build && cd build && cmake .. && make -j8 && sudo make install  
#引出雷达驱动so

# 删除 sudo 权限
USER root
RUN deluser $USERNAME sudo && sed -i "/$USERNAME ALL=(ALL) NOPASSWD:ALL/d" /etc/sudoers \
# && echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> /home/${USERNAME}/.bashrc \
&& echo 'source ~/Ros/rosws/devel/setup.bash' >> /home/${USERNAME}/.bashrc
USER $USERNAME
CMD ["/bin/bash"]
