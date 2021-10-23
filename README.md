## prodtracker

Simple script to record screenshots of your work and stitch them together into an mp4 file for each day.

Add a variation of this to your crontab to start automatically:

```
@reboot bash -l -c "sleep 10; export TARGETDIR=/home/matt/projects/prodtracker/saves; export DISPLAY=':0.0'; cd /home/matt/projects/prodtracker/ && ./start.sh 2>&1 | /usr/bin/logger -t prodtracker"
```

Make sure you specify the TARGETDIR, cd, and DISPLAY variables correctly! If it's not working, check syslog logs.
