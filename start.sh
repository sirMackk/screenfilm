#! /bin/bash

echo "Running stitcher"
./stitcher.sh

pgrep tracker.sh > /dev/null
rc=$?

if [ $rc -eq 0 ]; then
    echo "tracker already running"
    exit 0
fi

echo "Running tracker"
./tracker.sh &
