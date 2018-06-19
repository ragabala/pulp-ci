#!/usr/bin/env bash
set -euo pipefail

sudo yum -y install ansible attr git libselinux-python
echo 'localhost' > hosts
source "${RHN_CREDENTIALS}"
export ANSIBLE_CONFIG="${PWD}/ci/ansible/ansible.cfg"
ansible-playbook --connection local -i hosts ci/ansible/pulp_fips.yaml
