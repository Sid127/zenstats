#!/bin/bash

hwmon="/sys/class/hwmon"
mdevs=`ls $hwmon`
zenmon=""
ok=0

for dev in $mdevs; do
    path="$hwmon/$dev"
    devname=`cat $path/name`
    if [ "$devname" == "zenstats" ]; then
        cat $path/debug_data
        ok=1
    fi
done

if [ $ok -ne 1 ]; then
    echo "Zenstats not found"
    exit
fi
