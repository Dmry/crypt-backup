# Preparation / installation

### Install dependency

`sudo apt-get install cryptsetup`

### Create encrypted partition on destination drive
```shell
sudo cryptsetup -v --verify-passphrase luksFormat $EXTERNAL
sudo cryptsetup luksOpen $EXTERNAL backup
sudo mkfs.ext4 /dev/mapper/backup
sudo cryptsetup luksClose /dev/mapper/backup
```

### Set the correct disk locations
Connect relevant drives and run `sudo fdisk -l` to find your destination drives.  

Then in backup.sh edit the lines  
```shell
EXTERNAL=<fill in external disk locations (e.g. /dev/sdb) here>;
INTERNAL=<fill in internal disk locations (e.g. /dev/sda1) here>;
FILENAME=<fill in filename.img of backup here (e.g. computer.img)>;
```  

### Workings
The script will mount the encrypted disk created above.
 Next, it creates a folder named backup on your destination drive,
 so please check if there are any conflicts before running.
 Finally it creates a disk image named FILENAME.img of INTERNAL on EXTERNAL.
 When the backup is finished, the LUKS container will be dismounted and closed automatically.

### Set permissions and run script
cd into the directory containing backup.sh

When running for the first time 
`sudo chmod u+x backup.sh`

Then run
`./backup.sh`  

Alternatively, when in an SSH session the process can be daemonized using:  
WARNING: This assumes the locations in the script are correct.
`(echo y | nohup myprocess) &`

### Kill when daemonized:
`ps -ef | grep dmcrypt`

The second number is the PID. Kill the process using 
`sudo kill <pid>`

# Restore backup
Find the location of the drive containing your backup and a possible destination disk.
`sudo fdisk -l`

Open and mount this location. Replace /path/to/drive/with backup with the correct path found with fdisk.
```shell
cryptsetup luksOpen /path/to/drive/with/backup backup
mount /dev/mapper/backup /media/backup
```

Replace /path/to/drive/of/destination with the correct path found with fdisk.  
`sudo dd if=media/backup/server.img of=/path/to/drive/of/destination status=progress`
