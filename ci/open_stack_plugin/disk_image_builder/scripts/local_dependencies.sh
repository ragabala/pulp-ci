#!/bin/bash

sudo yum -y install policycoreutils-python-utils
setenforce 0
sudo yum -y install qemu-img

pip install --force-reinstall -U pip
pip install --force-reinstall -U setuptools

# installing openstack dependencies
pip install python-novaclient
pip install python-cinderclient
pip install python-glanceclient
pip install python-keystoneclient
pip install python-neutronclient
pip install python-swiftclient
pip install python-openstackclient

# installing the disk_image_builder
pip install diskimage-builder

