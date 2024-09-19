# --rm -> will delete the container once it is stopped
# -it -> interactive tty terminal
# -p 5901:5901 -> map port 5901 on the host to port 5901 in the container for VNC service
# -v -> mount local ./src directory to /home/ubuntu/src in the container
# -e "TERM=xterm-256color" -> environment variable to enable colored output in the terminal (user and @host name)
# --name -> ros: name the container 'ros'
# image -> run the 'ros_kinetic_vnc' image

docker run --rm -it -p 5901:5901 -e "TERM=xterm-256color" --name ros ros_kinetic_vnc