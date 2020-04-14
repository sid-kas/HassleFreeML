# /bin/bash 

source ./.config


run_build_dockerfile() 
{
    echo "building...";
    
    docker build --tag sidkas/simply_ssh:latest \
                 --build-arg SSH_PASS=$ssh_pass \
                 --build-arg INSTALL_ANACONDA=$install_anaconda .
}

clean_docker_stuff()
{
    docker stop $container_name
    docker rm $container_name
    docker image rm sidkas/simply_ssh:latest
}

docker_cpu() 
{
    # docker
    docker stop $container_name
    docker run \
        -it \
        --rm \
        --init \
        --volume=$mnt_path:/home/:rw \
        --publish $ssh_port:22 \
        --publish $jupyter_port:8888 \
        --name $container_name \
        sidkas/simply_ssh:latest
}
   
docker_gpu() 
{
    docker stop $container_name
    docker run \
        -it \
        --rm \
        --gpus $gpu_conf \
        --init \
        --volume=$mnt_path:/home/:rw \
        --publish $ssh_port:22 \
        --publish $jupyter_port:8888 \
        --name $container_name \
        sidkas/simply_ssh:latest

}

run_function() {
    echo "Excecuting function $1"
    if $1; then
        echo "Successfully excecuted! $1"
    else
        echo "Failed to excecuting!! $1"
    fi
}

print_help_msg(){
    head="=========================="
    clean="--clean: stop and remove container, remove image"
    cpu="--cpu : to set cpu env"
    gpu="--gpu : to set gpu env"
    build="--build : to build the dockerfile"
    echo -e "$head\nOptions:\n$build\n$cpu\n$gpu\n$clean\n$head\n"
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

main $*