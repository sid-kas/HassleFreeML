# /bin/bash 

source ./conf.sh


run_build_dockerfile() 
{
    echo "building...";
    
    docker build --tag sidkas/simply_ssh:latest \
                 --build-arg SSH_PASS=$ssh_pass .
}

docker_cpu() 
{
    # docker
    docker run \
        -it \
        --rm \
        --init \
        --volume=${HOME}:/home/:rw \
        --publish 5252:22 \
        --name $container_name \
        sidkas/simply_ssh:latest
}
   
docker_gpu() 
{
    docker run \
        -it \
        --rm \
        --gpus $gpu_conf \
        --init \
        --volume=${HOME}:/home/:rw \
        --publish 5252:22 \
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

main() {
    use_gpu=false
    build_dockerfile=false
    for var in "$@" 
    do 
        if [[ "$var" == *"--init"* ]]; then
            echo "works"
        fi
        if [[ "$var" == *"--gpu"* ]]; then
            use_gpu=true
        fi
        if [[ "$var" == *"--build"* ]]; then
            build_dockerfile=true
        fi
        if [[ "$var" == *"--help"* ]]|| [[ "$var" == *"-h"* ]]; then
            head="=========================="
            gpu="--gpu : to set gpu env"
            build="--build : to build the dockerfile"
            echo -e "$head\nOptions:\n$gpu\n$build\n$head\n"
        fi
    done

    if $use_gpu; then
        echo "using gpu"
        if $build_dockerfile; then
            echo "building dockerfile"
            run_function run_build_dockerfile
        fi
        run_function docker_gpu 
    else
        echo "not using gpu"
        if $build_dockerfile; then
            echo "building dockerfile"
            run_function run_build_dockerfile
        fi
        run_function docker_cpu
    fi
}

main $*