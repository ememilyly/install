#!/bin/bash

loadkeys us

# check efi
if [[ ! -d /sys/firmware/efi/efivars ]]; then
    echo "not in UEFI mode gl x"
    exit 1
fi

# get input for user and disks

read -p "hostname: " hostname < /dev/tty
read -p "user to create [emily]: " user < /dev/tty
user=${user:-emily}
echo "will create $user eventually"

echo
echo "partition disks"
echo "give me disk name i will wipe it and put one big partition on it"
echo "if you put home on the same disk it will all be one big happy partition"
echo "this WILL reformat specified disks so don't continue if you're a pussy"
echo
echo lsblk:
lsblk
echo
read -e -i "/dev/" -p "root disk: " root_disk < /dev/tty
read -e -i "/dev/" -p "home disk: " home_disk < /dev/tty
echo

# check they exist
if [ fdisk -l $root_disk $home_disk > /dev/null 2>&1 ]; then
    echo "i don't like those disks try again"
    exit 1
elif mount | grep -q -e $root_disk -e $home_disk; then
    echo "those are currently mounted"
    exit 1
fi

parted -s -a optimal $root_disk -- \
    mklabel gpt \
    mkpart efi fat32 1MiB 1GiB \
    set 1 esp on \
    mkpart root ext4 1GiB 100%

if [ $? != 0 ]; then
    echo "parted failed for some reason"
    exit 1
fi

efi_part=$root_disk"1"
root_part=$root_disk"2"

mkfs.fat -F 32 $efi_part
mkfs.ext4 $root_part

mount $root_part /mnt
mount --mkdir $efi_part /mnt/boot

if [ $home_disk != $root_disk ]; then
    parted -s -a optimal $home_disk -- \
        mklabel gpt \
        mkpart home ext4 1MiB 100%

    home_part=$home_disk"1"
    mkfs.ext4 $home_part
    mount --mkdir $home_part /mnt/home
fi

pacstrap -K /mnt base linux linux-firmware dhcpcd iwd grub efibootmgr vi vim man-db man-pages texinfo base-devel reflector zsh git xorg-server xorg-xinit xorg-xrandr xf86-video-nouveau xf86-video-intel xf86-video-fbdev ttf-dejavu kitty i3

genfstab -U /mnt >> /mnt/etc/fstab
echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo $hostname > /mnt/etc/hostname

cat <<EOF > /mnt/chroot-install.sh
#!/bin/bash

reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

sed -i '0,/^# %wheel/{s/^# %wheel/%wheel/}' /etc/sudoers

useradd -m -G wheel -s /bin/zsh $user
echo '#disable zsh config' > /home/$user/.zshrc
echo 'exec i3' > /home/$user/.xinitrc

systemctl enable dhcpcd
EOF

arch-chroot /mnt bash /chroot-install.sh
rm /mnt/chroot-install.sh

echo "arch-chroot /mnt and change root and $user password then reboot :)"
