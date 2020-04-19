# HassleFreeMLDevelopemnt

<h4 align="center">Demo</h4>
<p align="center">
    <img src=".github/demo.gif?raw=true" width="700">
</p>

### Quick start guide
- Make sure you have docker installed
    - If you are on **Windows or Mac** desktop go to https://www.docker.com/products/docker-desktop
    - On *bash* environment you can run ```bash install_docker.sh``` to install docker

- Initial build and run
```bash
    bash run.sh --build --cpu /path/to/dir
```
- already built
```bash
    bash run.sh --cpu
```
- already built gpu
```bash
    bash run.sh --gpu
```


**Simple run.sh options**:
- bash run.sh --help
- bash run.sh --build --cpu ./
- bash run.sh --build --gpu ./
- bash run.sh -gpu ./
- bash run.sh --clean

**Options**:
- */path/to/dir *: specifies nount path, default is set to pwd 
- *--build* : to build the dockerfile
- *--cpu* : to set cpu env and run
- *--gpu *: to set gpu env and run
- *--clean* : stop and remove container, remove image
- *--help or -h* : to see this message


- Change any configs using **configs/config.sh** file, it works as simple bash file to export env variables.

- Use login.sh from another terminal to ssh into the container (needs sshpass and ssh-keygen).
```bash
    bash login.sh
```
- Manual login (derived from **configs/config.sh** file)
```bash
    cmd: ssh root@localhost -p 5252
    pass: busy_box
```
**Once logged in**

- Run jupyter lab using ```bash configs/run_jupyterlab.sh &```, access it using jupyter_port (in configs/config.sh) external port

- mounted current working directory to *~/mount/* 

- **Copy/upload files:** scp -P $ssh_port -r /path/to/dir user@ip:~/remote_dir

### Configurations (from config.sh) for docker file and run.sh

| **Argument**     | **Type** | **Default** |
|------------------|----------|-------------|
| ssh_port         | int      | 5252        |
| ssh_pass         | str      | "busy_box"  |
| container_name   | str      | "blackbox"  |
| install_anaconda | bool     | false       |
| gpu_conf         | int/all  | all         |
| jupyter_port     | int      | 8987        |
| mnt_path         | str/bash | ${PWD}      |

### To do list

- check gpu config and verify gpu compatibility
- Login without password