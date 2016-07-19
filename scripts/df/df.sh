#!/bin/sh

TFILE1="$PWD"/temp1.txt
TFILE2="$PWD"/temp2.txt
die="$PWD"

disk_space(){
	echo "**********Disk Space Usage*******************" > $TFILE2
	df -h -T -P --exclude-type=aufs --exclude-type=squashfs --exclude-type=unionfs --exclude-type=devtmpfs --exclude-type=tmpfs --exclude-type=iso9660 --exclude-type=devfs --exclude-type=linprocfs --exclude-type=sysfs --exclude-type=fdescfs &> $TFILE2
}

disk_space
