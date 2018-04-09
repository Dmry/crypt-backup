#! /bin/bash

EXTERNAL=<fill in external disk locations (e.g. /dev/sdb) here>;
INTERNAL=<fill in internal disk locations (e.g. /dev/sda1) here>;
FILENAME=<fill in filename.img of backup here (e.g. computer.img)>;

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
                mkdir /media/backup >dev/null
                cryptsetup luksOpen $EXTERNAL backup
                mount /dev/mapper/backup /media/backup
		cd /media/backup
		echo "Creating backup, this can take a while.."
		echo "Press ctrl+z and then type bg to continue in the background"
                dd if=$INTERNAL of=/media/backup/$FILENAME status=progress > progress.log
		umount /dev/mapper/backup
		cryptsetup close backup
                ;;
        *)
                #or exit..
                echo "Please adjust disk locations in script file."
                exit
                ;;
esac

