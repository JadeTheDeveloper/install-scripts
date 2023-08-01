echo "Type your home partition, What type of disk do you have, type it below(sdx, vdx, nvme0n1(or the equivelent), mmcblk#), Also type your partition next to it"
read HOMEPARTITION
echo "Type your swap partition using the same format above"
read SAWPPARTITION
echo "Type your boot parition"
read BOOTPARTITION
echo "Mounting filesystems"
mount /dev/$HOMEPARTITION /mnt/gentoo
swapon /dev/$SAWPPARTITION
echo "Getting OpenRC base tarball"
wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20230730T170144Z/stage3-amd64-openrc-20230730T170144Z.tar.xz
mv stage3-amd64-openrc-20230730T170144Z.tar.xz /mnt/gentoo
cd /mnt/gentoo
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
echo "Edit your make.conf"
nano /mnt/gentoo/etc/portage/make.conf
echo "Configuring Eselect Repos"
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
echo "Mounting the fses for the chroot, your on your own after this"
echo "Run source /etc/profile after you get into the chroot"
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
chmod 1777 /dev/shm /run/shm
echo "Entering the chroot, youre on your own"
chroot /mnt/gentoo /bin/bash
