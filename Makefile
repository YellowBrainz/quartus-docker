.PHONY: all build bash run pull push

# http://download.altera.com/akdlm/software/acdsinst/16.0.1/218/ib_tar/Quartus-lite-16.0.1.218-linux.tar
# http://download.altera.com/akdlm/software/acdsinst/16.0/211/ib_installers/cyclonev-16.0.0.211.qdz

NAME=quartus
AUTHOR=yellowdocker

all: build

download-deps:
	mkdir -p ./quartus
	wget http://download.altera.com/akdlm/software/acdsinst/16.0.1/218/ib_tar/Quartus-lite-16.0.1.218-linux.tar -O ./quartus/Quartus-lite-16.0.1.218-linux.tar
	wget http://download.altera.com/akdlm/software/acdsinst/16.0/211/ib_installers/cyclonev-16.0.0.211.qdz -O ./quartus/cyclonev-16.0.0.211.qdz
	cd ./quartus; tar xf Quartus-lite-16.0.1.218-linux.tar

build:
	docker build -t $(AUTHOR)/$(NAME):latest .

bash:
	xhost +
	docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$(DISPLAY) --privileged -v /quartus:/quartus -v /dev:/dev $(AUTHOR)/$(NAME):latest /bin/bash

run:
	@echo "*****************************************************************************"
	@echo "Make sure SELinux is disabled, else docker cannot connect to your X11 socket!"
	@echo "After you install device drivers, just restart quartus from the xterm:"
	@echo "#############################################################################"
	@echo "/opt/altera_lite/quartus/bin/quartus"
	@echo "#############################################################################"
	@xhost +
	docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$(DISPLAY) --privileged -v /quartus:/quartus -v /dev:/dev $(AUTHOR)/$(NAME):latest

pull:
	docker pull docker.io/$(AUTHOR)/$(NAME):latest

push:
	docker tag $(AUTHOR)/$(NAME):latest docker.io/$(AUTHOR)/$(NAME):latest
	docker push docker.io/$(AUTHOR)/$(NAME):latest
