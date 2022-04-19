#!/bin/bash 

#ps -ef | grep track | awk '{print $2}' | xargs -I{} kill -9 {}
#ps -ef | grep stitch | awk '{print $2}' | xargs -I{} kill -9 {}


function pgrep() {
    ps aux | grep "$1" | grep -v grep | grep -v vim
}

pushd "$(dirname "$0")" || exit

pgrep tracker.sh > /dev/null
rc=$?

if [ $rc -eq 0 ]; then
  #commented out so don't keep getting mail
   #echo "tracker already running"
   exit 0
fi


echo "Running stitcher"
./stitcher.sh & 

# Wait for display to come up
sleep 2
echo "Running tracker"
./tracker.sh &
