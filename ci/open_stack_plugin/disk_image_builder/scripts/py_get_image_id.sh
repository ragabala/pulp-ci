#!/usr/bin/env bash

image_id=$(openstack image show $1 -f value --column id 2>/dev/null)

if [ -z "${image_id}" ];then
    image_id="0"
fi

echo "${image_id}"