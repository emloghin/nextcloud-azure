#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# defaults 
HOSTNAME="localhost"
USERNAME="emy"
PASSWORD="Cucus.005"
EMAIL="test@example.com"
STORAGEACCOUNT=""
CONTAINER=""

for i in "$@"
do
	case $i in
		--hostname=*)
		HOSTNAME="${i#*=}" 
		;;
		--username=*)
		USERNAME="${i#*=}"
		;;
		--password=*)
		PASSWORD="${i#*=}"
		;;
		--email=*)
		EMAIL="${i#*=}"
		;;
		--storageaccount=*)
		STORAGEACCOUNT="${i#*=}"
		;;	
		--container=*)
		CONTAINER="${i#*=}"
		;;			
		*)
		;;
	esac
done


#Install Dependencies

apt-get update
apt-get upgrade -y
apt-get install -y nfs-common

#Mount the file storage
mkdir -p /mnt/files
echo "$STORAGEACCOUNT.privatelink.blob.core.windows.net:/$STORAGEACCOUNT/$CONTAINER  /mnt/files    nfs defaults,sec=sys,vers=3,nolock,proto=tcp,nofail    0 0" >> /etc/fstab 
mount /mnt/files

#region install Docker
# check for more details https://docs.docker.com/engine/install/ubuntu/
apt-get update
apt-get install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
 tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
#endregion install Docker


#region install portainer
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
#endregion install portainer

