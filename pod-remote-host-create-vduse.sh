#!/bin/bash
/usr/bin/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
/usr/bin/ovs-vsctl add-port br0 vduse0 -- set Interface vduse0 type=dpdkvhostuserclient options:vhost-server-path=/dev/vduse/vduse0
/usr/bin/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:3b:00.0
#/usr/bin/ovs-vsctl add-port br0 vduse1 -- set Interface vduse1 type=dpdkvhostuserclient options:vhost-server-path=/dev/vduse/vduse1
sleep 5
ls -l /dev/vduse/*
vdpa dev add name vduse0 mgmtdev vduse
#vdpa dev add name vduse1 mgmtdev vduse
sleep 5
ip l
ethtool -i eth0
#ethtool -i eth1
ip netns add ns0
ip link set dev eth0 netns ns0
ip netns exec ns0 ip a a 192.168.101.1/24 dev eth0
ip netns exec ns0 ip l set dev eth0 up
#ip netns add ns1
#ip link set dev eth1 netns ns1
#ip netns exec ns1 ip a a 192.168.101.2/24 dev eth1
#ip netns exec ns1 ip l set dev eth1 up
#ip netns exec ns0 ping 192.168.101.2

echo 55555551,55555551 > /sys/class/vduse/vduse0/vq0/irq_cb_affinity
echo 55555551,55555551 > /sys/class/vduse/vduse0/vq1/irq_cb_affinity
#echo 55515551 > /sys/class/vduse/vduse1/vq0/irq_cb_affinity
#echo 55515551 > /sys/class/vduse/vduse1/vq1/irq_cb_affinity

cat /sys/class/vduse/vduse0/vq0/irq_cb_affinity
cat /sys/class/vduse/vduse0/vq1/irq_cb_affinity
#cat /sys/class/vduse/vduse1/vq1/irq_cb_affinity
#cat /sys/class/vduse/vduse1/vq0/irq_cb_affinity

#ovs-vsctl set interface br0 mtu_request=9000
#ovs-vsctl set interface vduse0 mtu_request=9000
#ovs-vsctl set interface vduse1 mtu_request=9000
#ip netns exec ns0 ip link set dev eth0 mtu 9000
#ip netns exec ns1 ip link set dev eth1 mtu 9000
ip netns exec ns0 ifconfig
#ip netns exec ns1 ifconfig
