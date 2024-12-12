#!/bin/bash

set -e

modprobe vduse
modprobe virtio-vdpa
lsmod | grep vduse


echo "killing old ovs process"
pkill -f ovs-vswitchd || true
sleep 5
pkill -f ovsdb-server || true

#echo "probing ovs kernel module"
#modprobe -r openvswitch || true
#modprobe openvswitch

echo "clean env"
DB_FILE=/etc/openvswitch/conf.db
rm -rf /var/run/openvswitch
mkdir /var/run/openvswitch
rm -f $DB_FILE

echo "init ovs db and boot db server"
export DB_SOCK=/var/run/openvswitch/db.sock
/usr/bin/ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
/usr/sbin/ovsdb-server --remote=punix:$DB_SOCK --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach --log-file
/usr/bin/ovs-vsctl --no-wait init

echo "start ovs vswitch daemon"
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init="true"
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:userspace-tso-enable="true"
/usr/bin/ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask="0x0040004"
/usr/sbin/ovs-vswitchd unix:$DB_SOCK --pidfile --detach --log-file=/var/log/openvswitch/ovs-vswitchd.log
