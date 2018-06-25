#!/usr/bin/env bash

echo "Setting up the node "
source prepare_node.sh

FIPS_FLAG=$(sudo cat /proc/sys/crypto/fips_enabled)

if [ "${DISTRIBUTION}" == "redhat" ] && [ $FIPS_FLAG == 0 ]; then
	echo "Enabling FIPS in the node"
	echo "Installing dracut-fips"
	sudo "${PKG_MGR}" install -y dracut-fips

	AES_CHECK=$(sudo grep aes /proc/cpuinfo)
	if [ ! "$AES_CHECK" = "" ]; then
		sudo "${PKG_MGR}" install -y dracut-fips-aesni
	fi

	echo "regenerating initramfs"
	sudo dracut -f

	# Capturing the file system mounted on boot
	BOOT_DEV=$(df /boot --output=source |tail -n+2)
	UUID_DEV=$(blkid $BOOT_DEV -o export |grep -i UUID)

	# Checking whether grub already contains fips information
	FIPS_IN_GRUB=$(sudo grep fips /etc/default/grub)

	if [  "$FIPS_IN_GRUB" = "" ]; then
		# Entering FIPS and Boot information in the grub file
		FIPS_IN_GRUB=$(sudo grep fips /etc/default/grub)
		if [  "$FIPS_IN_GRUB" = "" ]; then
			sed -i -E "s/^(.*GRUB_CMDLINE_LINUX=\")(.*)/\1fips=1 boot=$UUID_DEV \2/" /etc/default/grub
		fi
	fi

	if [ -d '/sys/firmware/efi' ]; then
	        grub2-mkconfig -o '/etc/grub2-efi.cfg'
	else
	         grub2-mkconfig -o '/etc/grub2.cfg'
	fi

fi


