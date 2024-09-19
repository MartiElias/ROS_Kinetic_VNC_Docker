FROM osrf/ros:kinetic-desktop-full

# Add ubuntu user with same UID and GID as your host system, if it doesn't already exist
# Since Ubuntu 24.04, a non-root user is created by default with the name vscode and UID=1000
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if ! id -u $USER_UID >/dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi
# Add sudo support for the non-root user
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch from root to user
USER $USERNAME

# Add user to video group to allow access to webcam
RUN sudo usermod --append --groups video $USERNAME

# Update all packages
RUN sudo apt update && sudo apt upgrade -y

# Install Git
RUN sudo apt install -y git vim nano

# Rosdep update
RUN rosdep update

# Source the ROS setup file
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# Add custom setup lines to .bashrc
RUN echo 'source /home/ubuntu/catkin_ws/src' >> /home/ubuntu/.bashrc && \
    echo 'source /home/ubuntu/catkin_ws/devel/setup.bash' >> /home/ubuntu/.bashrc

####### Tiger #######

# Refresh repository
RUN sudo apt update -y

# Install git and devscripts
RUN sudo apt install -y git devscripts and
RUN sudo apt install -y net-tools

# Remove vnc4server
RUN sudo apt remove -y vnc4server

# Create working directory
USER root
RUN mkdir -p home/$USERNAME/tigervnc
RUN cd home/$USERNAME/tigervnc
USER $USERNAME

RUN sudo apt-get update
RUN sudo apt-get install -y build-essential cmake libx11-dev libxext-dev libxrandr-dev \
    libxinerama-dev libxcursor-dev libxfixes-dev libxi-dev libxtst-dev libssl-dev \
    libjpeg-turbo8-dev libjpeg-dev

RUN sudo apt-get install -y libfltk1.3-dev


# Download the TigerVNC .deb package
RUN sudo apt install -y wget
RUN sudo wget https://sourceforge.net/projects/tigervnc/files/stable/1.7.0/ubuntu-16.04LTS/amd64/tigervncserver_1.7.0-1ubuntu1_amd64.deb/download -O tigervncserver_1.7.0-1ubuntu1_amd64.deb

# Install the package
RUN sudo dpkg -i tigervncserver_1.7.0-1ubuntu1_amd64.deb || true

# Fix any missing dependencies
RUN sudo apt-get install -y -f

# Verify the installation
#vncserver -version

# Reconfigure the package if needed
#sudo dpkg --configure tigervncserver

RUN sudo apt-get install -y x11-xkb-utils xkb-data

RUN sudo apt-get install -y x11-xserver-utils

RUN sudo dpkg-reconfigure -y x11-xkb-utils xkb-data || true

# Ensure the .vnc directory exists
RUN mkdir -p /home/$USERNAME/.vnc
RUN touch /home/$USERNAME/.Xauthority

# Set the VNC password
RUN echo "passwd" | vncpasswd -f > /home/$USERNAME/.vnc/passwd && chmod 600 /home/$USERNAME/.vnc/passwd

RUN sudo apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

# xstartup configuration
RUN touch /home/$USERNAME/.vnc/xstartup
RUN echo '#!/bin/sh\n\
export XKL_XMODMAP_DISABLE=1\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n\
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources\n\
xsetroot -solid grey\n\
vncconfig -iconic &\n\
gnome-panel &\n\
gnome-settings-daemon &\n\
metacity &\n\
nautilus &\n\
gnome-terminal &' > /home/$USERNAME/.vnc/xstartup

RUN chmod +x /home/$USERNAME/.vnc/xstartup

USER root

# Preconfigurar debconf para evitar pantallas interactivas
RUN echo "console-setup console-setup/charmap47 select UTF-8" | debconf-set-selections && \
    echo "console-setup console-setup/fontface47 select Fixed" | debconf-set-selections && \
    echo "console-setup console-setup/codeset47 select Guess optimal character set" | debconf-set-selections

# Instalar ubuntu-desktop de manera no interactiva
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop

USER $USERNAME

RUN echo 'export DISPLAY=:1' >> home/$USERNAME/.bashrc
RUN echo 'vncserver :1' >> home/$USERNAME/.bashrc


# GAZEBO models fix

RUN mkdir -p home/$USERNAME/.gazebo
#RUN mkdir -p home/$USERNAME/.gazebo/models
RUN git clone https://github.com/osrf/gazebo_models home/$USERNAME/.gazebo/models

#RUN echo 'export GAZEBO_MODEL_PATH=~/.gazebo/models:$GAZEBO_MODEL_PATH' >> home/$USERNAME/.bashrc

# Mover los archivos al directorio superior
#RUN mv home/$USERNAME/.gazebo/models/gazebo_models/* .

# Elimina la carpeta vacía si lo deseas
#RUN rmdir gazebo_models
