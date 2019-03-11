## Steps to create VM on SRIOV-Compute node
1) Assuming the deployment is running Contrail5.0.2+Openstack(Queens)
2) Create a flavor of type small, and upload image(driver installed) onto Glance  
3) Execute below commands
```
source .op/bin/activate
source /etc/kolla/kolla-toolbox/admin-openrc.sh
openstack flavor create --public small --id auto --ram 4096 --disk 40 --vcpus 2
openstack image create ugolden-img --public --container-format bare --disk-format qcow2 --file <image_file_name>
openstack network create nfv_sriov --provider-physical-network physnet1 --provider-segment 0
openstack subnet create nfv_subnet_sriov --network nfv_sriov --subnet-range 100.100.1.0/24 --no-dhcp
openstack port create --network nfv_sriov --fixed-ip subnet=nfv_subnet_sriov,ip-address=100.100.1.10 --vnic-type direct --disable-port-security sriov1
copy port-id from above command output, <port_id>
nova boot --image sriov-img --flavor small --nic port-id=<port_id> sriov-vm100
openstack server list
```
