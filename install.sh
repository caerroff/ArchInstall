#! /bin/bash
RED='\033[0;36m'
NC='\033[0m'
WHITE='\e[m'


echo -e "Welcome to ${RED}Arch Linux${NC}!" 
lsblk
echo
echo "Please choose the disk you want to install ArchLinux to (ex.  /dev/sda)"
read input									#  $input has the answer
echo "Format it like so:"
echo "	${input}1 : EFI partition (200M)"
echo "	${input}2 : Linux partition (full disk - swap [if desired])"
echo -e "	${input}3 : ${RED}[Optional]${NC} Swap partition (1G-4G)"
echo "Press any key when you are ready"
read delay
sudo cfdisk $input
answer=N
echo "did you create a swap ? [y/N]
if [ $answer -e [yY] ]; then
	echo "Creating swap..."
	mkswap ${input}3
	swapon ${input}3
fi
echo "Creating ext4 FileSystem"
mkfs.ext4 ${input}2 
echo "Creating EFI Parition"
mkfs.fat -F 32 ${input}1

sudo mount ${input}2 /mnt
sudo pacstrap /mnt base linux linux-firmware networkmanager efibootmgr grub sudo
sudo mount ${input}1 /mnt/boot
chroot /mnt /bin/bash -c "su - -c ./config.sh"

