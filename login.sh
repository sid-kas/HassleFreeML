# /bin/bash 
# if [ `id -u` -ne 0 ]; then
#     echo "*** This script can be executed only as root***"
#     echo "*** Exiting... ***"
#     exit 1
# fi
# set -e
# apt-get install sshpass

source ./config.sh
ssh-keygen -f "/root/.ssh/known_hosts" -R "[$ip]:$ssh_port"
sshpass -p $ssh_pass ssh -p $ssh_port -o StrictHostKeyChecking=no $user@$ip 