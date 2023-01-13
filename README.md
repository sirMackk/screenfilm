## screenfilm

Simple script to record screenshots of your work and stitch them together into an mp4 file for each day.

Inspired by this post by danluu: https://danluu.com/p95-skill/ who picked it from https://malisper.me/how-to-improve-your-productivity-as-a-working-programmer

External dependencies:
- scrot - for making screenshots
- ffmpeg - for stitching them together into mp4 videos

Add a variation of this to your crontab to start automatically:

```
#Mac
echo '0 0 */1 * * /Users/clarkbenham/screenfilm/start.sh' >> ~/.crontab
crontab ~/.crontab


@reboot bash -l -c "sleep 10; export TARGETDIR=/home/matto/projects/screenfilm/saves; export DISPLAY=':0.0'; cd /home/matto/projects/screenfilm/ && ./start.sh 2>&1 | /usr/bin/logger -t screenfilm"
```

Make sure you specify the TARGETDIR, cd, and DISPLAY variables correctly! If it's not working, check syslog logs.

## To playback from multiple monitors simultaneously
Open all videos with `open summary_*`. This commands assume you open 3 monitors, add or delete lines as appropriate.

To start all videos and play with a given speed settings
```
function start_vids {
  #playback rate, 1.1 is 10% faster
  speed=${1:-1}
  #sleep 2 &&
  osascript \
  -e 'tell application "QuickTime Player" to set rate of document 1 to '$speed \
  -e 'tell application "QuickTime Player" to set rate of document 2 to '$speed \
  -e 'tell application "QuickTime Player" to set rate of document 3 to '$speed
}
export -f start_vids
start_vids 1.1
```

To go to a given index, in seconds
```
function goto_vids {
  #eg. 120 for 2 min mark
  timestamp=$1 
  osascript \
  -e 'tell application "QuickTime Player" to set Time of document 1 to '$timestamp \
  -e 'tell application "QuickTime Player" to set Time of document 2 to '$timestamp \
  -e 'tell application "QuickTime Player" to set TIme of document 3 to '$timestamp
}
goto_vids 120
```

To stop
```
function stop_vids {
  osascript \
  -e 'tell application "QuickTime Player" to set rate of document 1 to 0' \
  -e 'tell application "QuickTime Player" to set rate of document 2 to 0' \
  -e 'tell application "QuickTime Player" to set rate of document 3 to 0'
}
stop_vids
```

To Start video again, but from 5 seconds ago
```
tunction restart_vids_back {
  num_sec_ago=${1:-5}
  speed=$2
  #Update video 1 then set to time of video 1 so that if this command is run while videos play, 3 doesn't get ahead of 1.
  osascript \
    -e 'tell application "QuickTime Player" to set current time of document 1 to current time of document 1 - '$num_sec_ago \
    -e 'tell application "QuickTime Player" to set current time of document 2 to current time of document 1' \
    -e 'tell application "QuickTime Player" to set current time of document 3 to current time of document 1'
 start_vids $speed
}
restart_vids_back 8 0.7
```

# To cleanup mp4 that have become corropted
convert to .mov if on mac: https://cloudconvert.com/mp4-to-mov

## TODO

- [x] Handle skip days (generate summary, clean up jpegs).
- [x] Handle suspends that cross the daily boundary.
