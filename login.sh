# /bin/bash 
if [ `id -u` -ne 0 ]; then
    echo "*** This script can be executed only as root***"
    echo "*** Exiting... ***"
    exit 1
fi
set -e
apt-get install sshpass

source ./conf.sh

sshpass -p $ssh_pass ssh -p $port -o StrictHostKeyChecking=no $user@$ip 