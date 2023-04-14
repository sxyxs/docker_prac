# https://hub.docker.com/r/pytorch/pytorch/tags?page=1&name=1.10.0
# this is the base image contains gcc 7.5 and nvcc available
FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-devel

# Install ubuntu packages
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        ca-certificates \
        sudo \
        locales \
        openssh-server \
        nano \
        vim && \
    # Remove the effect of `apt-get update`
    rm -rf /var/lib/apt/lists/* && \
    # Make the "en_US.UTF-8" locale
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Setup timezone
ENV TZ=Australia/Adelaide
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

####################################################################################
# START USER SPECIFIC COMMANDS
####################################################################################

ENTRYPOINT service ssh restart && bash

RUN python -m pip install detectron2==0.5 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu111/torch1.9/index.html

