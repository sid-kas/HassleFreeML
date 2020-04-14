# HassleFreeMLDevelopemnt

### Quick start guide
- Make sure you have docker installed

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
- Change any configs using **.config** file, it works as simple bash file to export env variables.

- Use login.sh from another terminal to ssh into the container (needs sshpass and ssh-keygen).
```bash
    bash login.sh
```
- Manual login (derived from **.config** file)
```bash
    cmd: ssh root@localhost -p 5252
    pass: busy_box
```
- Once logged in
    - Run jupyter lab using ```bash run_jupyterlab.sh &```, access it at 8989 external port
    - mounted current working directory to */home/* 
    - mount directory can be changed in **.config** file, using mnt_path




### To do
- check gpu config and verify gpu compatibility
- Login without password