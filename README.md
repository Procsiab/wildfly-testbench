# Wildfly Testbench

## Configuration

The system uses Vagrant with libvirt provider to start a 3 VM environment, with Centos 8 and Wildfly 18.

You can use it to tinker with Windfly's standalone and managed domain environment, configuring and deploying applications.

## Usage

You will need an SSH client and TMux installed on your host machine, other than an Internet connection to download some packets and the Wildfly binaries on the VMs.

To bootstrap your test bench, run the `./scripts/tmux_session_setup.sh` from the root directory of this project; note that more machines can be added, and some of their parameters can be tweaked too, like the RAM amount and CPU core count.

### libvirt and bridged networks

Libvirt provider does not allow the creation of bridge virtual network adapters from the userspace, using the `qemu:///session` socket; because of that, the default `virbr0` created by libvirt will be assumed to be present (*default* network) and used for the IP assignment of the VMs.

For the same reason, an XML file containing settings for a bridged private network is provided, for use with `virsh` run with the QEMU system socket.
