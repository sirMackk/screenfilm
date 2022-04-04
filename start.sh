#! /bin/bash

pgrep tracker.sh > /dev/null
rc=$?

if [ $rc -eq 0 ]; then
    echo "tracker already running"
    exit 0
fi

echo "Running stitcher"
./stitcher.sh & 2>&1

# Wait for display to come up
sleep 45
echo "Running tracker"
./tracker.sh &
