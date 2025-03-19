numactl -m 0 -N 0 ./pktgen_sample03_burst_single_flow.sh -i ens2f0np0 -m x.x.x.x -n 0 -t 1 -b 256 -s 64
numactl -m 0 -N 0 ./pktgen_sample03_burst_single_flow.sh -i ens2f0np0 -m x.x.x.x -n 0 -t 1 -b 256 -s 128
numactl -m 0 -N 0 ./pktgen_sample03_burst_single_flow.sh -i ens2f0np0 -m x.x.x.x -n 0 -t 1 -b 256 -s 256
numactl -m 0 -N 0 ./pktgen_sample03_burst_single_flow.sh -i ens2f0np0 -m x.x.x.x -n 0 -t 1 -b 256 -s 512
numactl -m 0 -N 0 ./pktgen_sample03_burst_single_flow.sh -i ens2f0np0 -m x.x.x.x -n 0 -t 1 -b 256 -s 1024

ifconfig ens2f0np0 192.168.101.2/24
netserver
pkill netserver
