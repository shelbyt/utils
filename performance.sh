#!/bin/bash

for i in {0..23}
do
    echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done
