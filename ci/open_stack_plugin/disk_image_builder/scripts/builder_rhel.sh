# Export the elements path so diskimage-builder can find the jenkins-slave
# element. The jenkins-slave element can be refered from here [1]
# [1] https://github.com/quipucords/ci/tree/master/ansible/roles/nodepool/files/elements/jenkins-slave
export ELEMENTS_PATH=$PWD/../elements

# Export the jenkins' public ssh key path in order to allow jenkins ssh into
# the slaves. The jenkins public key must be present in the following location
export JENKINS_PUBLIC_SSH_KEY_PATH=~/.ssh/jenkins/id_rsa.pub

######### FOR Building Fedora Images #######################
# Umcomment this Section for Fedora Images
#for DIB_RELEASE in 25 26 27; do
#   export DIB_RELEASE
#    disk-image-create -o "template-f${DIB_RELEASE}-os" fedora-minimal vm simple-init growroot jenkins-slave
#done

# there is now going to be images named "template-f25-os.qcow2",
# "template-f26-os.qcow2", "template-f27-os.qcow2" in whatever directory
# you are in.
############################################################3


# This is used by the bootloader element to insert values at boot time into grub
# Comment this out for Non Fips Machines
export DIB_BOOTLOADER_DEFAULT_CMDLINE="fips=1"



########## For CentOs Images ##############################
#export DIB_DISTRIBUTION_MIRROR="http://mirror.cs.princeton.edu/pub/mirrors/centos/"
# Build CentOS base image
#export DIB_RELEASE=7
#export IMAGE_NAME=template-centos7-os 
#disk-image-create -o template-centos7-os centos7 grub2 bootloader selinux-permissive jenkins-slave vm simple-init growroot epel
##########################################################



########## For Rhel Images ###############################
# Creating RHEL images is a little bit tricky in since there is no public image
# available. So you need to download the base image as noted here [1] and also
# export some other environement variables
# [1] https://github.com/openstack/diskimage-builder/tree/master/diskimage_builder/elements/rhel7

# Path to where the RHEL7 base image is
export DIB_LOCAL_IMAGE="$PWD/local_images/rhel-server-7.5-update-1-x86_64-kvm.qcow2"
	
# You can set the registration method for RHN with the environment variable
# REG_METHOD. Valid values include "disable" and "enable"

# If you want to add more repositories check [1] for more information about
# how to define the variable DIB_YUM_REPO_CONF.
# [1] https://github.com/openstack/diskimage-builder/tree/master/diskimage_builder/elements/yum
export REG_USER="rhn-engineering-automation"
export REG_PASSWORD=BI9ek0VNqUSbIWWn
export REG_POOL_ID=8a85f98c60c4fc0e0160c50f812d0430

disk-image-create -o template-rhel7-os rhel7 rhel-common vm simple-init growroot jenkins-slave grub2 bootloader selinux-permissive epel
##############################################################
