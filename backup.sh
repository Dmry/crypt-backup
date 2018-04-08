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
                eclipse &>mkdir /media/backup
                cryptsetup luksOpen $EXTERNAL backup
                mount /dev/mapper/backup /media/backup

                read -r -p "Daemonize process? (Recommended for SSH sessions)" DAEMONIZE
                case $DAEMONIZE in
                        [yY][eE][sS]|[yY])
				cd /media/backup
                                nohup dd if=$INTERNAL of=/media/backup/$FILENAME
				umount /media/backup
				cryptsetup close backup
				;;
                        *)
                        dd if=$INTERNAL of=/media/backup/$FILENAME status=progress
			umount /media/backup
			cryptsetup close backup
                        ;;
                esac
                ;;
        *)
                #or exit..
                echo "Please adjust disk locations in script file."
                exit
                ;;
esac

