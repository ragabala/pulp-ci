touch ./env_variables.sh
chmod +x ./env_variables.sh
cat "${RHN_CREDENTIALS}" >> ./env_variables.sh
cat "${Open_Stack_Credentials}" >> ./env_variables.sh
id
virtualenv ~/.venvs/openstack/
source ~/.venvs/openstack/bin/activate
./ci/open_stack_plugin/disk_image_builder/scripts/builder.sh
