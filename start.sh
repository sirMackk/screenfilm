#!/bin/bash -il

echo "WARN: if start as a cron job make sure have permissions to take screenshots of apps: https://apple.stackexchange.com/questions/378553/crontab-operation-not-permitted"

#Don't use this as cron; use a service instead

#ps -ef | grep track | awk '{print $2}' | grep -v vim |  xargs -I{} kill -9 {}
#ps -ef | grep stitch | awk '{print $2}' | grep -v vim | xargs -I{} kill -9 {}


function pgrep() {
    ps aux | grep "$1" | grep -v grep | grep -v vim
}

pgrep tracker.sh > /dev/null
rc=$?

#commented out echos so don't keep getting mail
if [ $rc -eq 0 ]; then
   #echo "tracker already running"
   exit 0
fi


#echo "Running stitcher"
## make paths absolute so can run in cron
/Users/clarkbenham/screenfilm/stitcher.sh & 

# Wait for display to come up
sleep 2
#echo "Running tracker"
/Users/clarkbenham/screenfilm/tracker.sh &
