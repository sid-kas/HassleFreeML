# /bin/bash 

run_function() {
    echo "Excecuting function $1"
    if $1; then
        echo "Successfully excecuted! $1"
    else
        echo "Failed to excecuting!! $1"
    fi
}

install_docker() {
    curl -sSL https://get.docker.com | sh
    apt-get install -y docker-compose
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ${USER}
    apt-get -qy upgrade
}

install_default_packages() {
    apt-get update && apt-get install -qy \
        sudo \
        htop \
        openssh-server \
        git \
        ca-certificates \
        curl \
        screen \
        tmux \
        software-properties-common \
        python-pip\
        python3-dev \
        libatlas-base-dev \
        python3-pip \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    apt-get -qy upgrade
}

install_requirements(){
    apt-get update && apt-get install -qy \
        sshpass \
        ssh-keygen 
}

run_function install_docker


## Uncomment these if you want install additional requirements
# run_function install_requirements
# run_function install_default_packages
