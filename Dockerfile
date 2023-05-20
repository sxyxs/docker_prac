# https://hub.docker.com/r/pytorch/pytorch/tags?page=1&name=1.10.0
# this is the base image contains gcc 7.5 and nvcc available
FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-devel

ARG MINICONDA=Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
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
        vim && \
    # Remove the effect of `apt-get update`
    rm -rf /var/lib/apt/lists/* && \
    # Make the "en_US.UTF-8" locale
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Setup timezone
ENV TZ=Australia/Adelaide
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/${MINICONDA} && \
    chmod +x miniconda.sh && \
    ./miniconda.sh -b -p conda && \
    rm miniconda.sh 
ENV PATH $HOME/conda/bin:$PATH
RUN touch $HOME/.bashrc && \
    echo "export PATH=$HOME/conda/bin:$PATH" >> $HOME/.bashrc && \
    conda init bash
# RUN conda create --name proj python=3.9 -y
# SHELL ["conda", "run", "-n", "proj", "/bin/bash", "-c"]
# command from pytorch.org
RUN conda install pytorch==1.9.0 torchvision==0.10.0 torchaudio==0.9.0 cudatoolkit=10.2 -c pytorch
# pytorch==1.9.0 torchvision==0.10.0 torchaudio==0.9.0 cudatoolkit=10.2 -c pytorch 
RUN conda clean -ya
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

#######################################################################################
# Project specific
#######################################################################################
# COPY requirements.txt requirements.txt
# RUN pip install -r requirements.txt

# Start openssh server
USER root

