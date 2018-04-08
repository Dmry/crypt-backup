# Preparation / installation

### Install dependency

`sudo apt-get install cryptsetup`

### Create encrypted partition on destination drive
```sudo cryptsetup -v --verify-passphrase luksFormat $EXTERNAL
sudo cryptsetup luksOpen $EXTERNAL backup
sudo mkfs.ext4 /dev/mapper/backup
sudo cryptsetup luksClose /dev/mapper/backup```

### Set permissions and run script
cd into the directory containing backup.sh

When running for the first time:
`sudo chmod u+x backup.sh`

Then run
`./backup.sh`

### Kill when daemonized:
`ps -ef | grep dmcrypt`

The second number is the PID. Kill the process:
`sudo kill <pid>`

# Restore backup
Find the location of the drive containing your backup and a possible destination disk.
`sudo fdisk -l`

Open and mount this location. Replace /path/to/drive/with backup with the correct path found with fdisk.
```cryptsetup luksOpen /path/to/drive/with/backup backup
mount /dev/mapper/backup /media/backup```

Replace /path/to/drive/of/destination with the correct path found with fdisk.
`sudo dd if=media/backup/server.img of=/path/to/drive/of/destination status=progress`
