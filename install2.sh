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
