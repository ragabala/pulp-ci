# Export the elements path so diskimage-builder can find the jenkins-slave
# element. The jenkins-slave element can be pulled from here [1]
# [1] https://github.com/quipucords/ci/tree/master/ansible/roles/nodepool/files/elements/jenkins-slave
export ELEMENTS_PATH=~/Documents/ragadocs/PULP/disk_image_builder/elements

# Export the jenkins' public ssh key path in order to allow jenkins ssh into
# the slaves
export JENKINS_PUBLIC_SSH_KEY_PATH=~/.ssh/jenkins/id_rsa.pub

# Export the dependent scripts on which the install scripts runs on 
export ELEMENTS_DEPENDENT_SCRIPT=~/Documents/ragadocs/PULP/disk_image_builder/scripts/

# Build Fedora base images
#for DIB_RELEASE in 25 26 27; do
#   export DIB_RELEASE
#    disk-image-create -o "template-f${DIB_RELEASE}-os" fedora-minimal vm simple-init growroot jenkins-slave
#done

# there is now going to be images named "template-f25-os.qcow2",
# "template-f26-os.qcow2", "template-f27-os.qcow2" in whatever directory
# you are in.

export DIB_BOOTLOADER_DEFAULT_CMDLINE="fips=1"
export DIB_DISTRIBUTION_MIRROR="http://mirror.cs.princeton.edu/pub/mirrors/centos/"
# Build CentOS base image
export DIB_RELEASE=7
export IMAGE_NAME=template-centos7-os 
disk-image-create -o template-centos7-os centos7 grub2 bootloader selinux-permissive jenkins-slave vm simple-init growroot epel


# Creating RHEL images is a little bit tricky in since there is no public image
# available. So you need to download the base image as noted here [1] and also
# export some other environement variables
# [1] https://github.com/openstack/diskimage-builder/tree/master/diskimage_builder/elements/rhel7

# Path to where the RHEL7 base image is
# export DIB_LOCAL_IMAGE="$PWD/localimages/rhel-guest-image-7.3-36.x86_64.qcow2"
	
# You can set the registration method for RHN with the environment variable
# REG_METHOD. Valid values include "disable" and "enable"

# If you want to add more repositories check [1] for more information about
# how to define the variable DIB_YUM_REPO_CONF.
# [1] https://github.com/openstack/diskimage-builder/tree/master/diskimage_builder/elements/yum

# disk-image-create -o template-rhel7-os rhel7 vm simple-init growroot jenkins-slave
