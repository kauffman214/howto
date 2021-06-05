# RAID CONFIGURATION #

## SETTING UP RAID ##

### SETTING UP THE SOFTWARE ###
MDADM is used to set up software raid on Linux

Installation of the essential packages. Most distributions include parted, but is listed below for good measure.

Debian based distributions
```
$ sudo apt-get update && sudo apt-get install mdadm parted
```
Redhat based distributions
```
$ sudo dnf install mdadm parted
```
Archlinux based distributions
```
$ sudo pacman -Sy mdadm parted
```

### IDENTIFYING THE DISKS ###
In the examples, /dev/sda, /dev/sdb, and /dev/sdc, /dev/sdd will be the reference disks.  These can be any other disk such as /dev/sdd (etc) and /dev/nvme1 (etc). There are a few ways to see disks, such as `fdisk -l` and `lsblk`

```
sudo lsblk
```
The following is a listing from a working Linux RAID 1 configuration
```
sda           8:0    0   3.7T  0 disk  
└─sda1        8:1    0   3.7T  0 part  
  └─md0       9:0    0   3.7T  0 raid1 /mnt/raid
sdb           8:16   0   3.7T  0 disk  
└─sdb1        8:17   0   3.7T  0 part  
  └─md0       9:0    0   3.7T  0 raid1 /mnt/raid
sdc           8:32   0   7.3T  0 disk  
└─sdc1        8:33   0   7.3T  0 part  /mnt/backup
nvme0n1     259:0    0 238.5G  0 disk  
├─nvme0n1p1 259:1    0     2G  0 part  
└─nvme0n1p2 259:2    0 236.5G  0 part  
nvme1n1     259:3    0 232.9G  0 disk  
├─nvme1n1p1 259:4    0   512M  0 part  /boot/efi
└─nvme1n1p2 259:5    0 232.4G  0 part  /
```
It is best to create a RAID array using partitions and not the raw disk.  When declaring the partition table type, there are two types that can be used: `gpt` and `mbr`.  For disks less < 2TB, use `mbr` (msdos) and for disks >2TB , use `gpt`.   For these examples, `parted` will be used.

In the examples below, replace `gpt` with `msdos` based on disk size.

### SETTING UP THE DISK ###
Initialize the disks.  This will destroy existing partition tables, so ensure you are selecting the correct disk.
```
$ sudo parted -s /dev/sda mklabel gpt
$ sudo parted -s /dev/sdb mklabel gpt
$ sudo parted -s /dev/sdc mklabel gpt
$ sudo parted -s /dev/sdd mklabel gpt
```
Partition the disks
```
$ sudo parted -s /dev/sda mkpart primary 1MiB 100%
$ sudo parted -s /dev/sdb mkpart primary 1MiB 100%
$ sudo parted -s /dev/sdc mkpart primary 1MiB 100%
$ sudo parted -s /dev/sdd mkpart primary 1MiB 100%
```
Set the raid flag on the disk (not the partition)
```
$ sudo parted -s /dev/sda set 1 raid on
$ sudo parted -s /dev/sdb set 1 raid on
$ sudo parted -s /dev/sdc set 1 raid on
$ sudo parted -s /dev/sdd set 1 raid on
```

## ESTABLISH THE DEVICE RAID ##
Only use the appropriate instructions for the type of RAID that needs to be installed.  RAIDS are created in degraded mode and will resync upon creation.  This may take some time, but the RAID can be used while undergoing resync.

### SETTING UP RAID 0 ###
NOTE: Only uses two disks of our reference disks for this example. This command is done in pairs.
```
$ sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sda1 /dev/sdb1 
```

### SETTING UP RAID 1 ###
NOTE: Only uses two disks of our reference disks for this example. This command is done in pairs.
```
$ sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdc1 /dev/sdd1 
```

### SETTING UP RAID 5 ###
NOTE: Three or more disks required.
```
$ sudo mdadm --create --verbose /dev/md0 --run --level=5 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1 
```
or
```
$ sudo mdadm --create --verbose /dev/md0 --run --level=5 --raid-devices=4 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
```
### SETTING UP RAID 6 ###
NOTE: Four or more disks required.
```
$ sudo mdadm --create --verbose /dev/md0 --run --level=6 --raid-devices=4 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
```

### SETTING UP RAID 6 ###
NOTE: Four or more disks required.
```
$ sudo mdadm --create --verbose /dev/md0 --run --level=6 --raid-devices=4 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
```

### SETTING UP RAID 0+1 ###
NOTE: Four or more disks required.
```
$ sudo mdadm --create --verbose /dev/md0 --run --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
$ sudo mdadm --create --verbose /dev/md1 --run --level=1 --raid-devices=2 /dev/sdc1 /dev/sdd1
$ sudo mdadm --create --verbose /dev/md2 --run --level=0 --chunk=64 --raid-devices=2 /dev/md0 /dev/md1
```

### ESTABLISHING THE FILESYSTEM ###
One the device is prepared, a file system must be installed to use the array.  For this exmaple, EXT4 will be used.
```
$ sudo mkfs.ext4 /dev/md0
```
Note: For the RAID 0+1, use /dev/md2

Obtain the UUID of the raid array for reference.  While it is possible to mount the array by device type, UUID the preferred option.
```
$ sudo lsblk -o UUID /dev/md0
```
The UUID is a canonical reference to the `/dev/md0` device.

One the file system is created, it will need to be mounted.  Note: the path for mounting can be any you choose (e.g. "/mnt/raid1")
```
$ sudo mkdir -P /mnt/raid1
```
Updating FSTAB to mount at boot time
```
$ sudo vi /etc/fstab
```
Add the following line to the `/etc/fstab` replacing `<myUUID>` with the UUID provided by the `lsblk` command.
```
UUID=<myUUID> /mnt/raid1 ext4 defaults,noatime 0 1
```

### MONITOR STATE OF RAID ###
To see information abou the state of the array use `--detail` with `mdadm`:  `sudo mdadm --detail /dev/md0`
For a "refreshed dashboard" view, you may opt to use watch to see the status updates in near real time: `watch sudo mdadm --detail /dev/md0`

To see the state of any member (e.g. disk) of the array:
```
$ sudo mdadm --examine /dev/sda1
```

## RAID DISK REPLACMENT ##
In the event of a disk failure, the disk will need to be replaced.  For the example, assume /dev/sdb1 failed

### MARK THE FAILED DISK ###

```
$ sudo mdadm --manage /dev/md0 --fail /dev/sdb1
```
Output should reflect
```
mdadm: set /dev/sdb1 faulty in /dev/md0
```
This should also be reflected in the raid details.
```
$ sudo mdadm --detail /dev/md0 
```

### REMOVE THE FAILED DISK ###
```
$ sudo mdadm --manage /dev/md0 --remove /dev/sdb1
```
The output should reflect:
```
mdadm: hot removed /dev/sdb1 from /dev/md0
```

### ADD THE NEW DISK ###
After physically attaching the new disk to the machine, set up the disk as was specified in SETTING UP THE DISK above, making sure to select the new disk and not an existing one.  Seleting an existing disk will destroy data. 

Add the new disk to the array (/dev/sdx1 is a placeholder for the actual device in the example)
```
$ sudo mdadm --manage /dev/md0 --add /dev/sdx1
```
Monitor the rebuild (e.g. --detail /dev/md0)

WITHIN the output you should see line items that include: `State : clean, degraded, recovering` and `spare rebuilding   /dev/sdx1`

Another option to just check the added drive itself is: `sudo mdadm --examine /dev/sda1 | grep State`

- - - -
## RAID TYPES ##

RAID 0 (striped):
Used for improved throughput performance.  Disk sets act in pairs to distribute read/write requests across the disk pairs.  Disks are striped and generally unrecoverable if 1 disk in the pair fails.

RAID 1 (mirrored):
Used for replication of data.  Data is written simultaneously across two or more disks of the array.  Data is recoverable by mounting a single disk of the array.

RAID 4 ('fast parity):
(Rarely) Used when you have a fast (e.g. ssd) in a setup where parity can be written to the fast drive and while data is written to the slower storage disks.

RAID 5:
Used for higher recoverability since all disks contain information about the data.  Three or more disks (N-1) are required in RAID 5 and are striped with data parity information (metadata about the data).  Data parity allows for the rebulding of data if a disk fails. Data is recoverable if 1 disk is lost in the array. 

RAID 6:
Used the same as RAID 5, but now there are two parity disks and a minimum of four disks are required to create this configuration.  This allows for recovery if two disks fail.

RAID 0+1:
Combines the techniques of RAID 0 and 1 to obtain the performance of RAID 0 and the replication of RAID 1.  This setup requires a minimum of 4 disks and is least cost effective solution.  Minimally, two stripe sets are created, then mirrored with each other.

RAID 10:
Not the same as RAID 0+1.  Stores muliple copies of the data across several drives; a two disk RAID 10 is the equivalent to RAID 1.  This mode scatters blocks all over the array and is difficult/ impossible to reshape.
