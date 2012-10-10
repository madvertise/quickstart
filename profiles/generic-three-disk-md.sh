. profiles/common/base.sh
. profiles/common/extra-volumes.sh
. profiles/common/md.sh
. profiles/common/net-current-reboot.sh

bootloader_install_device /dev/sda
bootloader_install_device /dev/sdb
bootloader_install_device /dev/sdc

part sda 1 fd00 1G
part sda 2 fd00

part sdb 1 fd00 1G
part sdb 2 fd00

part sdc 1 fd00 1G
part sdc 2 fd00

mdraid md1 --level=1 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1
mdraid md2 --level=5 --raid-devices=3 /dev/sda2 /dev/sdb2 /dev/sdc2

lvm_volgroup vg /dev/md2

format /dev/md1 ext3

mountfs /dev/md1 ext3 /
