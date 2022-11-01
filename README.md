# SUMO Docker Installation Guide

### 1. Introduction

This Dockerfile has only been tested on **Apple Silicon** Mac with **macOS 13.0 Ventura**. It is created as a workaround for Mac users with the latest macOS because of lack of the compatible Command Line Tool (CLT) to compile sumo packages. This guide contains the latest method of connecting X11 app via docker, while the old socket-passing way doesn't work and will not work [in the near future](https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949).

#### 1.1 Contents

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
2. Modify username to your preferred one at line 5. 
3. Open a terminal and navigate to the directory where the Dockerfile is located.
4. Run command "docker build -t sumo-docker ." (NOTE: there is a dot in the end of the command). It will take some time to build the image.
5. During the waiting time, we can continue to the following steps.

##### 2.2.3 Preparing launch script

1. Copy or move "sumo-gui.sh" to the working directory where you store your sumo configurations. (e.g. your local sumo folder holding configurations)
2. Open "sumo-gui.sh" in a text editor. 
3. Modify "SUMO_USER" (at line 3) to the username you have set for the Dockerfile.
4. Modify "WORKING_DIR" (at line 4) to the working directory you choose. The file in this directory will be visible to SUMO in the docker container at "/home/username/sumo". 
5. Check whether the docker image has been built. If it's done, proceed to the following steps.

#### 2.3 Usages

##### 2.3.1 Run sumo-gui

Run command:

```
zsh sumo-gui.sh
```

##### 2.3.2 Run netedit

* Modify "CMD" (at line 5) from "sumo-gui" to "netedit" in "sumo-gui.sh". Then run command:

```
zsh sumo-gui.sh
```

##### 2.3.3 Files saving and loading

In any SUMO app, when you opening an existing file or saving files, choose from "/home/username/sumo" in the container. In your host machine, all necessary files/folders should be available in the same working directory set in the "sumo-gui.sh"

##### 2.3.4 Customized Launching

* **[flexible start, suggested]** In order to run any command in the docker container, modifty "CMD" (at line 5) from "sumo-gui" to "/bin/bash" in "sumo-gui.sh". This will open an interactive terminal session for the container where you can run any command like "sumo-gui" and "netedit" without rerunning the script again when switching app.
* **[keeping container, not suggested]** If you want to keep the created container for next time (although it's not suggested since the image has the SUMO installed and the persisting data is store in the host Mac, except that you have modified/added new libs/packages to the existing container), you can remove "--rm" flag at line 11 in "sumo-gui.sh". From next launch, you need to run line 8 & 9 from the script first, then run the existing container. 

#### 2.4 Knowning issues

* In macOS Ventura, when you close a secondary window (e.g. saving window, config window), the main window will disappear. The application is actually still running, it's a bug in latest macOS. Activate mission control (control+up, or swipe up with 3 fingers, or Mission Control Key on Magic Keyboard if has), you will see a transparent XQuartz window, clicking on the window will bring it back.

### 3. References

* Fixing X11 fowarding for Mac Dorcker: <https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949>
* Fixing OpenGL errors: <https://github.com/XQuartz/XQuartz/issues/144#issuecomment-907511509>