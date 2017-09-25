STARTING REFRACTA INSTALLER  (9.2.3 in progress)

Refracta Installer will install the operating system to hard drive from
a running live-CD or live-USB session. The running system will be copied
exactly - any changes you make to the running system, including desktop
preferences, configuration changes, or added software will be copied to
the installed system.

You can run 'refractainstaller' from a terminal for the cli version.
For the graphical version, run Refracta Installer from the application
menu or start it from command line with 'refractainstaller-yad' (or
'refractainstaller-uefi' if you install on uefi hardware.)

See comments in /etc/refractainstaller.conf for various options that can
be set there.

Run pre-install scripts and Run post install scripts will enable
any scripts in /usr/lib/refractainstaller/pre-install or post-install
to run.

See /usr/lib/refractainstaller/installer_exclude.list if you want to
change the list of files/directories that won't be copied to the
installed system.  

Do not format filesystems: prevents the script from automatically 
formatting the partitions you select. You can use this if you pre-formatted
in gparted or cfdisk, and you can possibly use this option with other
filesystem types, such as btrfs.


INSTALLATION PROCEDURE

Start the installer, choose Simple or Expert.

Simple install puts the bootloader in the mbr of /dev/sda 
and lets you choose a single partition for the installation. That
partition will be formatted as ext3.

Expert install opens a window with a checklist of options.

  Change user name
  Create a separate /home partition
  Create a separate /boot partition
  Use existing swap partition (instead of swapfile.)
  Encrypt the root filesystem (separate /boot required)
  Encrypt the /home partition (separate /home required)
  Write random data to encrypted partitions (more secure)
  Write zeroes to all partitions (to erase previous data)
  Do not install bootloader. I'll handle it myself.
  Do not format filesystems. (You can format them ahead of time with gparted.)
  Use UUID in etc/fstab. (Useful if drive order changes.)
  Use filesystem labels (disk labels) in etc/fstab.
  Change hostname.
  Disable automatic login to desktop.
  Disable automatic login to console. (Use stock Debian inittab)
  Move selected directories to separate partitions.
  Run pre-install scripts
  Run post-install scripts

Run the partitioner if you need to.
Choose partition(s) and filesystem format(s) for installation.
Enter information if requested (new host name, disk labels, 
passphrases for encryption)
Sit back and watch for a few minutes.
Enter new username and password, root password or choose sudo.
Select any directories you want moved to another partition.
Reboot into the new installation.


CREATING ADDITIONAL SEPARATE PARTITIONS

If you chose to put /boot or /home on a separate partition, it (or they)
will be copied to the designated partition during the main part of the
installation.

If you want any directories other than /boot or /home on separate
partitions, for the gui installer, check "Move selected directories to 
separate partitions" in the expert options window, and for the text
installer, edit the config file to set additional_partitions="yes"

You must create and format the extra partitions during the partitioning
phase of the installation or before running the installer.

At the end of the installation, you will be asked to select the 
directories you want separate, and they will be copied to the selected
partitions. The contents of the original directory on the root filesystem
will then be deleted.









