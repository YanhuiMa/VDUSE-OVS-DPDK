VDUSE environment setup
./ovs-configuration.sh
./create-vduse.sh

VETH environment setup
./ovs-configuration.sh
need to remove following parameters
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init="true"
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:userspace-tso-enable="true"
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask="0x0040004"

./create-veth.sh
