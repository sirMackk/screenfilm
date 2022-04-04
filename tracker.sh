#! /bin/bash
set -e

screenint="${SCREENINT:-3}"

function set_today() {
    today=$(gdate --date="today" +"%m%d%y")
    echo "Set today's date: ${today}"
}

function get_dailydir() {
    dir="${TARGETDIR:-$HOME/prodtracker}"
    dailydir="${dir}/${today}"
    echo "${dailydir}"
}


function check_or_create_dir() {
    dailydir=$(get_dailydir)
    if [ ! -d "${dailydir}" ]; then
        mkdir -p "${dailydir}"
        echo "Directory absent, created: ${dailydir}"
    fi
}

function screenshot_loop() {
    #Change to writing jpegs
    defaults write com.apple.screencapture type jpg;killall SystemUIServer
    while true; do
        # If it's a new day, reset some variables and create a new directory for saving screenshots.
        date_now=$(gdate --date="today" +"%m%d%y")
        if [ "${date_now}" != "${today}" ]; then
            set_today
            check_or_create_dir
        fi
        dailydir=$(get_dailydir)

        # Allow for pausing capture
        if [ ! -f /tmp/trackerpause ]; then
            ts=$(date +"%H%M%S")
            num_monitors=$(system_profiler SPDisplaysDataType | grep -c Chipset)
            for monitor_ix in $(seq $num_monitors); do
              targetdir="${dailydir}/${ts}_m${monitor_ix}.jpg"
              screencapture -x -D $monitor_ix -t jpg  "${targetdir}"
            done
        fi
        sleep $screenint
    done
}

function main() {
    set_today
    check_or_create_dir
    screenshot_loop
}

main
