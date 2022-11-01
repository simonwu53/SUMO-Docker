#!/bin/zsh

SUMO_USER=devel
WORKING_DIR=/path/to/your/local/folder
CMD=sumo-gui

# enable X11 forwarding by net connection
xhost +localhost
export DISPLAY=:0

docker run -it --rm \
	-v $WORKING_DIR:/home/$SUMO_USER/sumo \
	-e DISPLAY=host.docker.internal:0 \
	-e SUMO_HOME=/usr/share/sumo \
	-e LIBGL_ALWAYS_INDIRECT=1 \
	--name sumo-test \
sumo-docker $CMD