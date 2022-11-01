# SUMO Docker Installation Guide

### 1. Introduction

This Dockerfile has only been tested on **Apple Silicon** Mac with **macOS 13.0 Ventura**, but generally the Dockerfile should be useful for others who wants to build SUMO docker on their own. It is created as a workaround for Mac users with the latest macOS because of lack of the compatible Command Line Tool (CLT) to compile sumo packages. This guide contains the latest method of connecting X11 app and enable OpenGL via docker, while the old socket-passing way doesn't work and will not work [in the near future](https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949).

Table of Contents
=================

* [SUMO Docker Installation Guide](#sumo-docker-installation-guide)
      * [1. Introduction](#1-introduction)
         * [1.1 Files in repo](#11-files-in-repo)
      * [2. Installation](#2-installation)
         * [2.1 Prerequisites](#21-prerequisites)
         * [2.2 Steps](#22-steps)
            * [2.2.1 Set up XQuartz](#221-set-up-xquartz)
            * [2.2.2 Build docker image](#222-build-docker-image)
            * [2.2.3 Preparing launch script](#223-preparing-launch-script)
      * [3. Usages](#3-usages)
         * [3.1 Run sumo-gui](#31-run-sumo-gui)
         * [3.2 Run netedit](#32-run-netedit)
         * [3.3 Files saving and loading](#33-files-saving-and-loading)
         * [3.4 Customized Launching](#34-customized-launching)
      * [4. Knowning issues](#4-knowning-issues)
      * [5. Trouble shooting &amp; References](#5-trouble-shooting--references)

#### 1.1 Files in repo

* Dockerfile - docker file instructions for creating container image
* README.md - this file as a manual for installation
* sumo-gui.sh - startup file used to launch app after building the SUMO image

### 2. Installation

#### 2.1 Prerequisites

* macOS (Other OS not tested, you can use this Dockerfile as a base for other OS though)
* Apple Silicon Mac (X11 forwarding and Xquartz only tested on these Macs, Intel Mac not tested but could try)
* Docker installed: see doc from [here](https://docs.docker.com/desktop/install/mac-install/).
* [XQuartz.app](http://XQuartz.app) installed: from [Homebrew](https://formulae.brew.sh/cask/xquartz). Make sure "/opt/X11/bin" or "/usr/X11/bin" is in your "PATH" environmental variable (You may need to logout/login or restart your Mac to make the settings take effect).
* A text editor at your choice.
* A terminal at your choice.

#### 2.2 Steps

All steps will take approx. 3-10 mins.

1. Download "Dockerfile" and "sumo-gui.sh" to your local disk.

##### 2.2.1 Set up XQuartz

1. Launch XQuartz. Under the XQuartz menu, select Preferences
2. Go to the security tab and ensure "Allow connections from network clients" is checked. Close Preferences window.
3. Open a terminal. 
4. Type "defaults write org.xquartz.X11 enable_iglx -bool true" and hit enter key. This will write settings to enable OpenGL for XQuartz, which is used in SUMO. Close terminal.
5. Logout and login again, or fully restart your Mac.

##### 2.2.2 Build docker image

1. open "Dockerfile" in a text editor.
2. Modify username to your preferred one at line 5. Save the modified file.
3. Open a terminal and navigate to the directory where the Dockerfile is located.
4. Run command "docker build -t sumo-docker ." (NOTE: there is a dot in the end of the command). It will take some time to build the image.
5. During the waiting time, we can continue to the following steps.

##### 2.2.3 Preparing launch script

1. Copy or move "sumo-gui.sh" to the working directory where you store your sumo configurations. (e.g. your local sumo folder holding configurations)
2. Open "sumo-gui.sh" in a text editor. 
3. Modify "SUMO_USER" (at line 3) to the username you have set for the Dockerfile.
4. Modify "WORKING_DIR" (at line 4) to the working directory you have chosen. The file in this directory will be visible to SUMO in the docker container at "/home/username/sumo". 
5. Save the modified file.
6. Check whether the docker image has been built. If it's done, proceed to the following steps.

### 3. Usages

#### 3.1 Run sumo-gui

Run command:

```
zsh sumo-gui.sh
```

#### 3.2 Run netedit

* Modify "CMD" (at line 5) from "sumo-gui" to "netedit" in "sumo-gui.sh". Then run command:

```
zsh sumo-gui.sh
```

For other apps, do the same as above. 


#### 3.3 Files saving and loading

In any SUMO app, when you opening an existing file or saving a file, choose from "/home/username/sumo" in the container. On your host machine, all necessary files/folders should be available in the same working directory set in the "sumo-gui.sh".

#### 3.4 Customized Launching

* **[flexible start, suggested]** In order to run any command in the docker container, modifty "CMD" (at line 5) from "sumo-gui" to "/bin/bash" in "sumo-gui.sh". This will open an interactive terminal session for the container where you can run any command like "sumo-gui" and "netedit" without rerunning the script again when switching app.
* **[keeping container, not suggested]** If you want to keep the created container for next time (although it's not suggested since the image has the SUMO installed and the persisting data is store on the host Mac, except that you have modified/added new libs/packages to the existing container), you can remove "--rm" flag at line 11 in "sumo-gui.sh". From next launch, you need to run line 8 & 9 from the script first, then run the existing container. 
* Feel free to make your own customized lauchning script.

### 4. Knowning issues

* In macOS Ventura, when you close a secondary window (e.g. saving window, config window), the main window will disappear. The application is actually still running, it's a bug in latest macOS. Activate mission control (control+up, or swipe up with 3 fingers, or Mission Control Key on Magic Keyboard if has), you will see a transparent XQuartz window, clicking on the window will bring it back.

### 5. Trouble shooting & References 

* If you just want to make X11 forwarding work on Mac Docker, go through this comprehensive tutorial: <https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949>
* If your docker X11 app needs to enable OpenGL, do the following steps on your Mac:
  * Follow the steps in section [2.2.1 Set up XQuartz](#221-set-up-xquartz)
  * Run the following lines every time before starting your docker app (you can make it automatic): 

```
# enable connection from localhost
xhost +localhost
# specify the correct DISPLAY variable
export DISPLAY=:0
```

  * Add the following arg when using "docker run":
  
```
-e LIBGL_ALWAYS_INDIRECT=1 
``` 

  * Further reading, see original posts here: <https://github.com/XQuartz/XQuartz/issues/144#issuecomment-907511509>