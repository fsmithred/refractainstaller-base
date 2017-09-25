#!/usr/bin/env bash
# move-dir-mount.sh

. gettext.sh
TEXTDOMAIN=refractainstaller-base
export TEXTDOMAIN
TEXTDOMAINDIR=/usr/share/locale
export TEXTDOMAINDIR

#set -x

# Send errors to the installer's error log.
error_log=$(grep error_log /etc/refractainstaller.conf | cut -d"\"" -f2)
exec 2>> "$error_log"

move_dir () {
# Select the directory you want to move to another partition
echo -n $"

 Enter the directory you want to move to another partition.
 Do not use a trailing slash.
 (examples:  /var or /usr
 "
read source_dir

if [[ -z "$source_dir" ]] ; then
	echo $"Error: You didn't enter a directory. Nothing will be moved."
	exit 0
fi



# Make sure the user select selects source_dir from the new installation, mounted at /target


# Enter the destination partition.
echo -n $"

 Enter the destination partition for /${source_dir##*/}.
 (example: /dev/sdb3)
 "
read destination_partition

if [[ -z "$destination_partition" ]] ; then
	echo $"Error: You didn't enter a partition. Nothing will be moved."
	exit 0
fi

if ! [[ -b "$destination_partition" ]] ; then
	echo $"Error: $destination_partition is not a valid block device. Nothing will be moved."
	exit 0
fi

if [[ ${destination_partition:8:1} != [1-9] ]]; then
	echo $"Error: $destination_partition is not a valid partition. Nothing will be moved."
	exit 0
fi

# Temporary mount point for the other partition, just to copy the files.
dirname="${source_dir##*/}"
temp_mountpoint="$(mktemp -d /tmp/$dirname.XXXXXX)"

echo "1 $source_dir  ********"
echo "2 $destination_partition  **********"
echo "3 $temp_mountpoint  ***********"

mount "$destination_partition" "$temp_mountpoint"
rsync -av --progress /target"$source_dir"/ "$temp_mountpoint"/ 

idnum=$(blkid -c /dev/null -o value -s UUID "$destination_partition")
fstype=$(blkid -c /dev/null -o value -s TYPE "$destination_partition")

echo -e "UUID=$idnum\t$source_dir\t$fstype\tdefaults,noatime\t0\t2"  >> /target/etc/fstab

rm -rf /target"$source_dir"/*
umount "$temp_mountpoint"
rmdir "$temp_mountpoint"

ask_again

}

ask_again () {
while true; do
	echo -n $"
 Do you want to move another directory to a separate partition? (y,N):
 "
	read ans
	case $ans in
		[Yy]*)	move_dir; break ;;
		*)		exit 0 ;;
	esac
done
	
}

move_dir

exit 0
