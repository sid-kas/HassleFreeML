FROM tensorflow/tensorflow:latest-gpu-py3

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,video,utility

ENV SHELL=/bin/bash

RUN apt-get update && apt-get install -y \
        sudo \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    apt-utils \
    ca-certificates \
    curl \
    software-properties-common \
    swig \
    wget \
    nano \
    vim \
    cmake \
    zlib1g-dev \
    libjpeg-dev \
    xvfb \
    xorg-dev \
    libboost-all-dev \
    libsdl2-dev \
    swig \
    libgtk2.0-dev \
    unzip \
    aptitude \
    pkg-config \
    qtbase5-dev \
    libqt5opengl5-dev \
    libassimp-dev \
    libtinyxml-dev \
    screen \
    terminator \
    tmux \
    libcanberra-gtk-module \
    libfuse2 \
    libnss3 \
    fuse \
    libglfw3-dev \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    net-tools \
    xpra \
    xserver-xorg-dev \
    libffi-dev \
    libxslt1.1 \
    libglew-dev \
    parallel \
    htop \
    apt-transport-https

WORKDIR /root/

COPY ./configs/* ./configs/

RUN pip install --upgrade pip && pip install --upgrade -r configs/requirements.txt

ARG INSTALL_ANACONDA

RUN if $INSTALL_ANACONDA; then \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p ~/miniconda && \
    rm ~/miniconda.sh && \
    export PATH=~/miniconda/bin:$PATH; \
    fi

RUN if $INSTALL_ANACONDA; then \
    /bin/bash -c "source /root/.bashrc && \
                  export PATH=~/miniconda/bin:$PATH && \
                  conda init && \
                  source /root/.bashrc && \
                  conda env create -f configs/conda-cpu.yml && \
                  conda env create -f configs/conda-gpu.yml && \
                  conda activate cpu";\
    fi

RUN curl -sSL https://get.docker.com | sh

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

ARG SSH_PASS
ENV SSH_PASS ${SSH_PASS}

RUN echo -e "root:$SSH_PASS" | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]