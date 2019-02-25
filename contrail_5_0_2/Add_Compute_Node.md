# Add SR-IOV compute node to an existing contrail cluster
1.) Update instances.yaml with SR-IOV compute node information
2.) Run the below commands
```
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/configure_instances.yml
ansible-playbook -i inventory/ -e orchestrator=openstack --tags nova playbooks/install_openstack.yml
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/install_contrail.yml
```
3.) Check contrail-status on new compute node, using command
```
contrail-status
```
