#! /bin/bash

echo "Running stitcher"
./stitcher.sh & 2>&1

pgrep tracker.sh > /dev/null
rc=$?

if [ $rc -eq 0 ]; then
    echo "tracker already running"
    exit 0
fi

# Wait for display to come up
sleep 45
echo "Running tracker"
./tracker.sh &
