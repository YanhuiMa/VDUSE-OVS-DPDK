a=`ip netns exec ns0 cat /sys/class/net/eth0/statistics/rx_packets`
sleep 20
b=`ip netns exec ns0 cat /sys/class/net/eth0/statistics/rx_packets`
echo $a $b
c=`expr $b - $a`
d=`expr $c / 20`
echo $d
