#!/bin/bash

dir="${TARGETDIR:-$HOME/prodtracker}"
pushd "$dir" &>/dev/null || (echo "couldn't cd to $dir" &&  exit ) #absolute paths for cron

#echo "WARN: if start as a cron job make sure have permissions to take screenshots of apps: https://apple.stackexchange.com/questions/378553/crontab-operation-not-permitted"

#Don't use this as cron; use a service instead

#ps -ef | grep track  | grep -v 'vim\|grep' | awk '{print $2}'   |  xargs -I{} kill -9 {}
#ps -ef | grep stitch | grep -v 'vim\|grep' | awk '{print $2}' | xargs -I{} kill -9 {}


function already_running() {
    pgrep -f "tracker.sh" | grep -cv 'grep\|vim\|nvim'
}

#commented out echos so don't keep getting mail
if [[ $(already_running) -gt 0  ]]; then
   #echo "tracker already running"
   exit 0
fi


#echo "Running stitcher"
## make paths absolute so can run in cron
/Users/clarkbenham/screenfilm/stitcher.sh </dev/null & 

# Wait for display to come up
sleep 2
#echo "Running tracker"
/Users/clarkbenham/screenfilm/tracker.sh </dev/null &
