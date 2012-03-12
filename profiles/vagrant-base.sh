. profiles/virtualbox-single-disk.sh
. profiles/common/vagrant.sh

post_install() {
	vagrant_post_install
	install_guest_additions
	compact_with_cleanup
	compact_with_zero_fill

	# do not return with failure
	true
}
