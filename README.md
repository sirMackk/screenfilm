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

## To playbay from multiple monitors simultaneously
Open all videos, postion, and then to play all at a given speed settings
```
sleep 2 &&
osascript \
-e 'tell application "QuickTime Player" to set rate of document 1 to 1.5' \
-e 'tell application "QuickTime Player" to set rate of document 2 to 1.5' \
-e 'tell application "QuickTime Player" to set rate of document 3 to 1.5'
```

To go to a given index, in seconds
```
timestamp=90
osascript \
-e 'tell application "QuickTime Player" to set Time of document 1 to '$timestamp \
-e 'tell application "QuickTime Player" to set Time of document 2 to '$timestamp \
-e 'tell application "QuickTime Player" to set TIme of document 3 to '$timestamp
```


## TODO

- [x] Handle skip days (generate summary, clean up jpegs).
- [x] Handle suspends that cross the daily boundary.
