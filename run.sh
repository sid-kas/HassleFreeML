# /bin/bash 

source ./configs/config.sh

run_function() {
    echo "Excecuting function $1"
    if $1; then
        echo "Successfully excecuted! $1"
    else
        echo "Failed to excecuting!! $1"
    fi
}

run_build_dockerfile() 
{
    echo "building...";
    
    docker build --tag sidkas/simply_ssh:latest \
                 --build-arg SSH_PASS=$ssh_pass \
                 --build-arg INSTALL_ANACONDA=$install_anaconda .
}

clean_docker_stuff()
{
    remove_container
    docker image rm sidkas/simply_ssh:latest
}

remove_container(){
    docker stop $container_name
    docker rm --force $container_name
}

docker_init_run() {
    # docker
    if remove_container; then
        echo "Successfully removed latest container \nStarting docker now..."
    else
        echo -e "No running container found! \nStarting docker now..."
    fi
    sleep 1
    head="=========================="
    echo -e "$head\nDocker running successfully now, to login use \ncmd: ssh $user@$ip -p $ssh_port \npass: $ssh_pass"
    echo -e "Mounted Directory: $mnt_path \nJupyter port : $jupyter_port"
}

docker_cpu() 
{
    docker_init_run

    docker run \
        -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --init \
        --volume=$mnt_path:/root/mount/:rw \
        --publish $ssh_port:22 \
        --publish $jupyter_port:8888 \
        --name $container_name \
        sidkas/simply_ssh:latest
    
}
   
docker_gpu() 
{
    docker_init_run
    
    docker run \
        -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --rm \
        --gpus $gpu_conf \
        --init \
        --volume=$mnt_path:/root/mount/:rw \
        --publish $ssh_port:22 \
        --publish $jupyter_port:8888 \
        --name $container_name \
        sidkas/simply_ssh:latest

}

print_help_msg(){
    head="=========================="
    clean="--clean : stop and remove container, remove image"
    cpu="--cpu : to set cpu env and run"
    gpu="--gpu : to set gpu env and run"
    build="--build : to build the dockerfile"
    _help="--help or -h : to see this message"
    echo -e "$head\nOptions:\n$build\n$cpu\n$gpu\n$clean\n$_help\n$head\n"
}

main() {
    use_gpu=false
    build_dockerfile=false
    help_msg=false
    clean_up=false
    use_cpu=false

    for var in "$@" 
    do 
        if [[ "$var" == *"--cpu"* ]]; then
            use_cpu=true
        fi
        if [[ "$var" == *"--clean"* ]]; then
            clean_up=true
        fi
        if [[ "$var" == *"--gpu"* ]]; then
            use_gpu=true
        fi
        if [ -d "$var" ]; then
            mnt_path=$(cd -- "$var" && pwd)
        fi
        if [[ "$var" == *"--build"* ]]; then
            build_dockerfile=true
        fi
        if [[ "$var" == *"--help"* ]]|| [[ "$var" == *"-h"* ]]; then
            help_msg=true
        fi
    done

    if $clean_up; then
        run_function clean_docker_stuff
    fi

    if $use_gpu; then
        echo "using gpu"
        if $build_dockerfile; then
            echo "building dockerfile"
            run_function run_build_dockerfile
        fi
        run_function docker_gpu 
    elif $help_msg; then
        print_help_msg
    elif $use_cpu; then
        echo "using default config..."
        echo "not using gpu, to use gpu add arg --gpu"
        if $build_dockerfile; then
            echo "building dockerfile"
            run_function run_build_dockerfile
        fi
        run_function docker_cpu
    elif $build_dockerfile; then
        echo "using default config..."
        echo "not using gpu, to use gpu add arg --gpu"
        echo "building dockerfile"
        run_function run_build_dockerfile
    else
        print_help_msg
    fi
}

check_if_docker_exists(){
    head="=========================="
    docker_desktop="1) If you are on Linux or Mac desktop go to https://www.docker.com/products/docker-desktop"
    docker_sh="2) On bash environment you can run bash install_docker.sh to install docker"
    abort_msg="Required docker but it's not installed.  Aborting."
    command -v docker >/dev/null 2>&1 || { echo -e >&2 "$head\n$abort_msg\nTo install docker:\n$docker_desktop\n$docker_sh\n$head"; exit 1; }
}

check_if_docker_exists
main $*