#!/usr/bin/env bash
# Tested on Centos 7 and Ubuntu 16.04

set -e

EXITCODE=0

function deploy_on_ubuntu ()
{
   echo "Installing required tools on ubuntu.."
   sudo apt-get install pciutils -y
   sudo apt-get install numactl -y
   sudo apt-get install hwloc -y
   sudo apt-get install lshw -y
}

function deploy_on_centos ()
{
   echo "Installing required tools on centos.."
   sudo yum install pciutils -y
   sudo yum install numactl -y
   sudo yum install hwloc -y
   sudo yum install lshw -y
}

if [ -f /etc/lsb-release ]; then
   deploy_on_ubuntu
elif [ -f /etc/redhat-release ]; then
   deploy_on_centos
else
   echo "Unsupported OS for now !!!"
   EXITCODE=1
fi

exit $EXITCODE
