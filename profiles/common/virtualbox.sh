compact_with_cleanup() {
	spawn_chroot "emerge -C ${kernel_sources}"
	spawn_chroot "rm -rf /usr/src/linux-* /var/cache/genkernel"
	spawn_chroot "rm -rf /usr/portage/distfiles/* /usr/portage/packages/*"
}

compact_with_zero_fill() {
	for part in / /usr /var; do
		spawn_chroot "cat /dev/zero > ${part}/zero.fill; sync; rm -f ${part}/zero.fill; sync"
	done
}

post_install() {
	# setup hostname
	echo "127.0.0.1 vagrant-zentoo.vagrantup.com vagrant-zentoo localhost" > ${chroot_dir}/etc/hosts
	echo "hostname=\"vagrant-zentoo\"" > ${chroot_dir}/etc/conf.d/hostname

	# setup user
	spawn_chroot "useradd -m -d /home/vagrant -g users -G wheel,portage,cron vagrant"
	spawn_chroot "echo vagrant:vagrant | chpasswd"
	spawn_chroot "curl -s -k -L https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys"

	# sudo configuration
	cat <<EOF > ${chroot_dir}/etc/sudoers
Defaults env_keep="EDITOR SSH_AUTH_SOCK"
root    ALL = (ALL) ALL
%wheel  ALL = (ALL) NOPASSWD: ALL
EOF

	# do not return with failure
	true
}
