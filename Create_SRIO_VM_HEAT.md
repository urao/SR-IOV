## Steps to create VM on SRIOV-Compute node
1.) Assuming the deployment is running Contrail5.0.2+Openstack(Queen)
2.) Create a flavor of type small, and upload image(driver installed) onto Glance  
3.) Copy [heat template files]() here
3.) Run below commands
```
source .op/bin/activate
source /etc/kolla/kolla-toolbox/admin-openrc.sh
openstack flavor create --public small --id auto --ram 4096 --disk 40 --vcpus 2
openstack image create ugolden-img --public --container-format bare --disk-format qcow2 --file <image_file_name>
openstack stack create -e create-sriov-vm.env -t create-sriov-vm.yaml <stack_name>
openstack stack list
```
