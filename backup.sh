#! /bin/bash

EXTERNAL=/dev/sdb;
INTERNAL=/dev/sda1;
FILENAME=server.img;

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

echo "Listing specified disks..."
echo "Destination:"
sudo fdisk -l | grep $EXTERNAL
echo "Original:"
sudo fdisk -l | grep $INTERNAL
read -r -p "Is this correct [Y/n]" RESPONSE
case "$RESPONSE" in
        [yY][eE][sS]|[yY])
                mkdir /media/backup >dev/null 2>dev/null
                cryptsetup luksOpen $EXTERNAL backup
                mount /dev/mapper/backup /media/backup

		cd /media/backup
		echo "Creating backup, this can take a while.."
                dd if=$INTERNAL of=/media/backup/$FILENAME status=progress &>progress.log
		umount /media/backup
		cryptsetup close backup
                ;;
        *)
                #or exit..
                echo "Please adjust disk locations in script file."
                exit
                ;;
esac

