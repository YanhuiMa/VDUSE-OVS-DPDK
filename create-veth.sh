#!/bin/bash

/usr/bin/ovs-vsctl add-br br1
ip link add veth0.0 type veth peer veth0.1 netns ns0
/usr/bin/ovs-vsctl add-port br1 veth0.0
nmcli device set veth0.0 managed no
ip l set dev veth0.0 up
ip netns exec ns0 ip a a 192.168.102.1/24 dev veth0.1
ip netns exec ns0 ip l set dev veth0.1 up
ip link add veth1.0 type veth peer veth1.1 netns ns1
/usr/bin/ovs-vsctl add-port br1 veth1.0
nmcli device set veth1.0 managed no
ip l set dev veth1.0 up
ip netns exec ns1 ip a a 192.168.102.2/24 dev veth1.1
ip netns exec ns1 ip l set dev veth1.1 up
ovs-vsctl set interface br1 mtu_request=9000
ovs-vsctl set interface veth0.0 mtu_request=9000
ovs-vsctl set interface veth1.0 mtu_request=9000
ip netns exec ns0 ip link set dev veth0.1 mtu 9000
ip netns exec ns1 ip link set dev veth1.1 mtu 9000
ip netns exec ns0 ifconfig
ip netns exec ns1 ifconfig
