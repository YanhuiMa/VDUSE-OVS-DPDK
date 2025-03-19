#!/bin/bash

# Variables
NETPERF_SERVER="66:55:ef:75:24:75"  # Replace with the IP address of the netperf server
NETPERF_TEST_DURATION=60      # Test duration in seconds
CPU_LOG_FILE="cpu_utilization.log"
NETPERF_LOG_FILE="netperf_output.log"
CPU_SUMMARY_FILE="cpu_utilization_summary.log"

# Array of packet sizes to test (in bytes)
#PACKET_SIZES=(64 128)
PACKET_SIZES=(64 128 256 512 1024 2048 4096 8192)
#PACKET_SIZES=(128 256)


# Function to calculate average CPU utilization
calculate_cpu_utilization() {
    echo "Calculating average CPU utilization..."
    # Extract the %idle column for all CPUs and calculate the average CPU usage
    awk '
    BEGIN { total_usage = 0; count = 0; }
    /all/ && NF > 3 { 
        usage = 100 - $13;  # Assuming %idle is in column 12
        total_usage += usage;
        count++;
    }
    END {
        if (count > 0) {
            avg_usage = total_usage / count;
            print "Average CPU Utilization: " avg_usage "%";
        } else {
            print "No CPU utilization data found.";
        }
    }' "$CPU_LOG_FILE" >> "$CPU_SUMMARY_FILE"
    echo "Average CPU utilization saved to: $CPU_SUMMARY_FILE"
}

# Run netperf test for each packet size
run_test() {
    for PACKET_SIZE in "${PACKET_SIZES[@]}"; do
        echo "Starting netperf test with packet size: ${PACKET_SIZE} bytes"
        echo "Netperf test output will be saved to: $NETPERF_LOG_FILE"
        echo "CPU utilization will be logged to: $CPU_LOG_FILE"
        
        # Start mpstat in the background to monitor CPU utilization
        mpstat -P ALL 1 > "$CPU_LOG_FILE" &

        # Get the PID of the mpstat process
        MPSTAT_PID=$!

        # Run netperf with specified packet size and save its output
	#numactl -m 0 -N 0 ip netns exec ns1 ./pktgen_sample01_simple.sh -i eth1 -m "$NETPERF_SERVER" -n 10000000 -t 1 -s "$PACKET_SIZE" | grep "Result: OK" -A 1 | tail -n 1 >> "$NETPERF_LOG_FILE"
	#numactl -m 0 -N 0 ip netns exec ns1 ./pktgen_sample03_burst_single_flow.sh -i eth1 -m "$NETPERF_SERVER" -n 10000000 -t 1 -s "$PACKET_SIZE" | grep "Result: OK" -A 1 | tail -n 1 >> "$NETPERF_LOG_FILE"
	numactl -m 0 -N 0 ip netns exec ns1 ./pktgen_sample01_simple.sh -i veth1.1 -m "$NETPERF_SERVER" -n 10000000 -t 1 -s "$PACKET_SIZE" | grep "Result: OK" -A 1 | tail -n 1 >> "$NETPERF_LOG_FILE"

        # Stop mpstat process
        kill $MPSTAT_PID
        wait $MPSTAT_PID 2>/dev/null

        # Calculate average CPU utilization
        calculate_cpu_utilization

        # Log the results for this packet size
        echo "Test for packet size ${PACKET_SIZE} bytes completed."
    done
}

# Main execution
run_test
