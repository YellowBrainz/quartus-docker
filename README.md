Quartus 16.0 docker container
-----------------------------

Authors: Maxim Belooussov / Toon Leijtens
Date   : July 2016

With this docker you can install and run a Quartus 16.0 on your pc. Mind you that
before this installation you will need to have downloaded the big files (quartus
binary and the device file). The Dockerfile will retrieve these files from a local
server. It's an exercise for the reader to build this trvial feature.

These files will be copied in the docker image and used for building the
dockerized quartus application.

This distribution comes with an Makefile (distributed from our Github repo.) Use
this Makefile to build the docker image and launch Quartus.

To build this yellowbrainz/quartus image use:
```
make build
```

To run the Quartus application simply use:
```
DISPLAY=(ip-address):0 make run
```

You just need to have your display port open for the world (my hint to you: `xhost +`).


OSX Specifics
-------------

+--- IMPORTANT NOTE ----------------
: OSX Today (Docker 1.12.0.rc4-beta20 build: 10404) does not provide a working way
: to map a usb port from the host into the container that we try to start.
: Although this may change in the future. You are adviced to use the boot2docker
: (Docker toolbox) edition. unless you only want to synthesize circuits, that is.
: Because then there is no real need for a USB mapping. I thought you should know!
+---

Now since we need to move to a boot2docker setup, also the mapping of a folder
outside the /Users space becomes tricky. For this to work you will need to stop
the vm (in my case this vm is called default) and then perform a few specific
actions like so:

```
docker-machine stop
```

VBoxManage sharedfolder add default --name /quartus --hostpath /quartus --automount
```
docker-machine start
docker-machine ssh default
```
Now on the docker machine you will need to add a file in the called;

```
sudo vi /var/lib/boot2docker/bootlocal.sh
```

The content of this file will need to be:

```
#!/bin/sh
# mind you there is no bash in a boot2docker vm!
mkdir -p /quartus
mount -t vboxsf /quartus /quartus
```

The latter will mount /quartus on the host with the /quartus folder on the boot2docker
instance. After editing, make sure that the shell script is executable;

```
sudo chmod 755 bootlocal.sh
```

This is the moment, now you should reboot the vm (in Virtualbox) and the system should
come up with the mapped /quartus folder between host and docker container.

Next stop on our journey is to add the X11 features that we need for this
project, so let's go about and fix that.

On OSX you must first install XQuartz. This will allow OSX to run as a X11
host. On OSX you also require a small helper application to allow docker to
connect the X-port (TCP) from docker to the host.

Here are the required commands that you need to run for this. This procedure
assumes that you have build the docker. So that this is ready for use.

```
brew update
brew install socat
brew cask install xquartz
```

// Upto this point all required software is available. now we can start xquartz
// but before that you will need to find the IP address for your display port.
// run the ifconfig command and lookup the real ip-address (IP4).
//
// NOTE:  localhost or default address set in DISPLAY does not work!!!
// NOTE2: when using boot2docker lookup the ip address of your vboxnet it's this
//        inet address that you will have to use. 

```
open -a XQuartz && socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

Now in a new window run your docker container:

```
DISPLAY (yourhost-ip):0 make run
```
