# How to bring up SR-IOV Infra on Centos 7.5 and validation
0.) Ensure VT-d and ASPM is enabled in BIOS
1.) First check if the interface support SR-IOV functionality
2.) Install required tools on the server, by running [script]() 
3.) Run below commands to verify if interface supports SR-IOV
```
lspci -v | grep Eth
lspci -vvv -s <pci bus id>
```
4.) Get \<pci bus id\> using command "ethtool -i <interface_name>"
5.) Check the version of the igbe/ixgbe driver installed for interface, using command
```
ethtool -i <interface_name>
```
6.) If correct version of the driver is not installed, download and upgrade the driver from intel [website](http://downloadmirror.intel.com)
7.) If required, igbvf driver can also be downloaded and upgraded from intel [website](http://downloadmirror.intel.com)
8.) Modify grub to add the below line
```
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=""/c\GRUB_CMDLINE_LINUX_DEFAULT=" nomdmonddf nomdmonisw intel_iommu=on"' /etc/default/grub
/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg
dracut -f -v
reboot
```
9.) Check total number of VF's supported by the interface, using
```
cat /sys/class/net/<interface_name>/device/sriov_totalvfs
```
10.) Depending on how VF's required for your VNF, run the below command to create those many of them, in my case 10
```
echo "10" /sys/class/net/<interface_name>/device/sriov_numvfs
```
11.) Check the network devices
```
ip link show dev <interface_name>
ip link set <interface_name> up
```
12.) Install KVM packages on the server using the [script]()
13.) Create a VM with image(igbe driver) either using virt-manager console or virsh command
14.) Run the following to check the VF details and attached interface to VM, based on 82599ES NIC card
```
lspci | grep 82599
81:00.0 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
81:00.1 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
81:10.1 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
81:10.3 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
```
15.) Identify the PCI device matching bus id "0000:81:10.1"
```
virsh nodedev-list | grep pci
*pci_0000_81_10_1*
```
15.) Gather information about the domain, bus and function:
```
virsh nodedev-dumpxml pci_0000_81_10_1
```
16.) Sample output of the above command
```
<device>
  <name>pci_0000_81_10_1</name>
  <path>/sys/devices/pci0000:80/0000:80:03.0/0000:81:10.1</path>
  <parent>pci_0000_80_03_0</parent>
  <driver>
    <name>ixgbevf</name>
  </driver>
  <capability type='pci'>
    <domain>0</domain>
    <bus>129</bus>
    <slot>16</slot>
    <function>1</function>
    <product id='0x10ed'>82599 Ethernet Controller Virtual Function</product>
    <vendor id='0x8086'>Intel Corporation</vendor>
    <capability type='phys_function'>
      <address domain='0x0000' bus='0x81' slot='0x00' function='0x1'/>
    </capability>
    <iommuGroup number='45'>
      <address domain='0x0000' bus='0x81' slot='0x10' function='0x1'/>
    </iommuGroup>
    <numa node='1'/>
    <pci-express>
      <link validity='cap' port='0' width='0'/>
      <link validity='sta' width='0'/>
    </pci-express>
  </capability>
</device>
```
17.) Create /var/tmp/new-interface.xml file with below information
```
<interface type='hostdev' managed='yes'>
	<mac address='01:02:03:04:05:08'/>
	<source>
		<address type='pci' domain='0' bus='129' slot='16' function='1'/>
	</source>
</interface>
```
18.) Attach this new interface to existing instance/VM:
```
virsh attach-device <instance-0000001a> /var/tmp/new-interface.xml --live --config
```
19.) Login to VM/instance and check the new interface using:
```
ip addr show
ifconfig
```
20.) On the server/node, check the new MAC address assigned to VF using:
```
ip link show dev <interface_name>
```
