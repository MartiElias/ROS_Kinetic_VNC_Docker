
# ROS Kinetic with Docker and VNC

Welcome to the **ROS Kinetic with Docker and VNC** project. This repository allows you to install and use ROS Kinetic inside a Docker container, providing a stable and consistent development environment for ROS across different platforms including Linux, Mac, and Windows. Additionally, it features support for remote access through TigerVNC, enabling a graphical interface accessible from any system with a VNC client.

## Prerequisites
- **Docker**: Ensure Docker is installed on your system. You can find installation instructions for your operating system on the official Docker website.
- **VNC Client**: To access the remote desktop of the container, you will need a VNC client. Any compatible VNC client like `RealVNC` or `TightVNC` will work.

## Compatibility
This container version is specifically designed to work with **ROS Kinetic** on **Ubuntu 16.04**. Due to the age of this Ubuntu version and incompatibilities with newer versions of TigerVNC, an older, tested version of TigerVNC is used to ensure proper operation.

## Configuration
The repository is organized into folders corresponding to different operating systems, each with specific configurations and scripts for that platform.

### Repository Structure
- **Dockerfile**: Base file used to build the Docker image with ROS Kinetic.
- **Linux/Windows WSL**:
  - **start_ros_vnc.sh**: Script to start the container with TigerVNC support.
  - **connect_ros.sh**: Script to connect to the container with an interactive terminal.
- **Mac/Windows**:
  - **start_ros_vnc.sh**: Script to start the container with TigerVNC support.
  - **connect_ros.sh**: Script to connect to the container with an interactive terminal.

### Building the Image
To build the Docker image with ROS Kinetic, run the following command:

```bash
docker build -t ros_kinetic_vnc .
```

### Starting the Container
Once the image is built, you can start the container with VNC support using the following command:

```bash
./start_ros_vnc.sh
```

This script will run the Docker container and enable the VNC server, allowing you to connect to the graphical environment of ROS Kinetic. By default, port 5901 will be used for the VNC connection.

### Connecting to the Graphical Environment
To access the graphical environment of ROS Kinetic, open your VNC client and connect to `localhost:5901`. Enter the default password "passwd" specified in the `Dockerfile` (you can change this in the file if desired).

### Connecting to the Terminal
If you wish to open additional terminals within the container, you can use the `connect_ros.sh` script to start a new interactive session.

```bash
./connect_ros.sh
```

### Making the Scripts Executable
Before running the provided `.sh` scripts, make sure they have executable permissions. You can grant these permissions using the following command:

```bash
chmod +x file.sh
```

### Note on Limitations
- The container is configured to use TigerVNC due to compatibility issues with newer versions of TigerVNC and Ubuntu 16.04.
- Currently, noVNC support is not implemented in this container version. Remote access is limited to VNC.

## Contributions
If you encounter any issues or wish to improve this repository, feel free to open an issue or send a pull request. Any contributions, whether adding new scripts, improving documentation, or enhancing cross-platform compatibility, are welcome.
