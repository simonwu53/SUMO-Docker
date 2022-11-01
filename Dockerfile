# based on ubuntu 22.04 image
FROM ubuntu:22.04

# set variable
ENV SUMO_USER devel

# meta
LABEL Author="Shan Wu"
LABEL Description="Dockerized SUMO ver 1.8.0 (from default PPA), X11 forwarding enabled for macOS"

# install latest SUMO from ppa:sumo/stable
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:sumo/stable
RUN apt-get update
RUN apt-get -y install sumo sumo-tools sumo-doc

# maybe useful for Intel AMD graphics if encountered openGL issue
# not needed by macOS
# RUN apt-get -y install libgl1-mesa-glx mesa-utils libgl1-mesa-dri

# create user directory (may not be necessary?)
RUN groupadd -g 1000 $SUMO_USER
RUN useradd -d /home/$SUMO_USER -s /bin/bash -m $SUMO_USER -u 1000 -g 1000
USER $SUMO_USER
ENV HOME /home/$SUMO_USER

# create working directory for the ITS course
RUN mkdir /home/$SUMO_USER/sumo

# default entry point for the image
CMD /usr/bin/sumo-gui