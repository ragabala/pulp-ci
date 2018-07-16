#!/bin/bash

if [[ -f ./env_variables.sh ]];then
    echo "sourcing environment variables for this build"
    source ./env_variables.sh
fi
echo "value imported $OS_AUTH_URL"

# Directory of the script
scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Path to the Disk Image Builder Elements
export ELEMENTS_PATH="${scripts_dir}/../elements"

# Installing the required dependencies
source "${scripts_dir}/local_dependencies.sh"
source "${scripts_dir}/base_image_config.conf"

# The jenkins public key must be present in the following location
export JENKINS_PUBLIC_SSH_KEY_PATH=~/.ssh/jenkins/id_rsa.pub

# create the input and output directories
rm -rf  "${scripts_dir}/output_images"; mkdir -p "${scripts_dir}/output_images"
rm -rf "${scripts_dir}/input_images"; mkdir -p "${scripts_dir}/input_images"

get_image_id_from_name(){
    _image_id_temp="$(openstack image show -c id -f value ${1} 2> /dev/null)"
}


download_base_image(){
    # glance --file file_location image_id_openstack
    local temp="${1}_${2}"
    get_image_id_from_name "${!temp}"
    echo "downloading  ${_image_id_temp}"
    glance image-download --progress --file  "${scripts_dir}/input_images/${1}_${2}_base.img" "${_image_id_temp}"
}


remove_existing_image(){
    echo "removing ${1}_${2}_${3}_DIB_updated"
    value="${1}_${2}_${3}_DIB_updated"
    get_image_id_from_name ${value}
    if [[ ${_image_id_temp} ]];then
        echo "deleting existing image ${_image_id_temp}"
        glance image-delete ${_image_id_temp}
    fi
}


upload_image(){
    temp="${1}_${2}"
    remove_existing_image ${1} ${2} ${3}
    echo "uploading ${temp}"
    glance image-create --progress  --disk-format qcow2 --container-format bare --visibility private --file "${scripts_dir}/output_images/template-${1}${2}-os.qcow2" --name "${1}_${2}_${3}_DIB_updated"
}


build_fedora_images(){
local OS="fedora"
for DIB_RELEASE in 27; do
   export DIB_RELEASE
   download_base_image $OS $DIB_RELEASE
   export DIB_LOCAL_IMAGE="$scripts_dir/input_images/${OS}_${DIB_RELEASE}_base.img"
   disk-image-create -o "${scripts_dir}/output_images/template-${OS}${DIB_RELEASE}-os" redhat-common fedora vm simple-init growroot jenkins-slave
   upload_image $OS $DIB_RELEASE 'common'
done

}

build_centos_images(){
local OS='centos'
export DIB_RELEASE=7
download_base_image $OS $DIB_RELEASE
export DIB_LOCAL_IMAGE="$scripts_dir/input_images/${OS}_${DIB_RELEASE}_base.img"
disk-image-create -o "${scripts_dir}/output_images/template-${OS}${DIB_RELEASE}-os" centos7 grub2 bootloader selinux-permissive jenkins-slave vm simple-init growroot epel
upload_image $OS $DIB_RELEASE 'common'
}


build_rhelos_images(){
local OS='rhel'
export DIB_RELEASE=7
download_base_image $OS $DIB_RELEASE
export DIB_LOCAL_IMAGE="$scripts_dir/input_images/${OS}_${DIB_RELEASE}_base.img"
export DIB_BOOTLOADER_DEFAULT_CMDLINE="fips=1"
export REG_USER=$RHN_USERNAME
export REG_PASSWORD=$RHN_PASSWORD
export REG_POOL_ID=$RHN_SKU_POOLID
export REG_METHOD=portal
# Fips Rhel
disk-image-create -o "${scripts_dir}/output_images/template-${OS}${DIB_RELEASE}-os" rhel7 rhel-common vm simple-init growroot jenkins-slave bootloader epel
upload_image $OS $DIB_RELEASE 'fips'

# Non Fips Rhel
export DIB_BOOTLOADER_DEFAULT_CMDLINE=""
disk-image-create -o "${scripts_dir}/output_images/template-${OS}${DIB_RELEASE}-os" rhel7 rhel-common vm simple-init growroot jenkins-slave epel
upload_image $OS $DIB_RELEASE 'common'
}

build_fedora_images
build_rhelos_images
