 vdpa dev del vduse0
 vdpa dev del vduse1
 ovs-vsctl del-port br0 vduse0
 ovs-vsctl del-port br0 vduse1
 ovs-vsctl del-br br0

 ip link delete veth1.0
 ip link delete veth0.0
