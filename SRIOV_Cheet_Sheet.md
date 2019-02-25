## Cheat sheet with commands to execute on SRIOV-Compute node
1.) To capture PCI Vendor ID and product id
```
lspci -nn | grep "Virtual Function"
```
2.) Useful commands
```
lspci | grep Ethernet
lspci -v | grep -i eth | grep "Virtual Function"
cat /proc/cpuinfo
hwloc-ls
ifconfig <PF_INTERFACE> promisc
ifconfig <PF_INTERFACE> allmulti
ifconfig <PF_INTERFACE> mtu 9192
lshw -c network -businfo
modinfo ixgbe
```
