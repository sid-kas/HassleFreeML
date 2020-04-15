# HassleFreeMLDevelopemnt

### Quick start guide
- Make sure you have docker installed
    - If you are on **Windows or Mac** desktop go to https://www.docker.com/products/docker-desktop
    - On *bash* environment you can run ```bash install_docker.sh``` to install docker

- Initial build and run
```bash
    bash run.sh --build --cpu
```
- already built
```bash
    bash run.sh --cpu
```
- already built gpu
```bash
    bash run.sh --gpu
```
- Change any configs using **config.sh** file, it works as simple bash file to export env variables.

- Use login.sh from another terminal to ssh into the container (needs sshpass and ssh-keygen).
```bash
    bash login.sh
```
- Manual login (derived from **config.sh** file)
```bash
    cmd: ssh root@localhost -p 5252
    pass: busy_box
```
- Once logged in
    - Run jupyter lab using ```bash run_jupyterlab.sh &```, access it using jupyter_port (in config.sh) external port
    - mounted current working directory to */home/* 
    - mount directory can be changed in **config.sh** file, using mnt_path


### Configureations for docker file

| **Argument**     | **Type** | **Default** |
|------------------|----------|-------------|
| ssh_port         | int      | 5252        |
| ssh_pass         | str      | "busy_box"  |
| container_name   | str      | "blackbox"  |
| install_anaconda | bool     | false       |
| gpu_conf         | int/all  | all         |
| jupyter_port     | int      | 8987        |
| mnt_path         | str/bash | ${PWD}      |

### To do
- check gpu config and verify gpu compatibility
- Login without password