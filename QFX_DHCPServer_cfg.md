## Sample QFX-5100 DHCPServer configuration
1.) Below condifuration helps to assign IP address to SRIOV VM interfaces
```
set system services dhcp-local-server group server1 interface xe-0/0/0.0
set interfaces xe-0/0/0 unit 0 family inet address 10.0.33.1/24
set access address-assignment pool poo1 family inet network 10.0.33.0/24
set access address-assignment pool poo1 family inet range range1 low 10.0.33.20
set access address-assignment pool poo1 family inet range range1 high 10.0.33.30
set access address-assignment pool poo1 family inet dhcp-attributes name-server 8.8.8.8
set access address-assignment pool poo1 family inet dhcp-attributes router 10.0.33.1
```
