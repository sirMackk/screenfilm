#! /bin/bash

today=$(date +"%m%d%y")

dir="${TARGETDIR:-~/prodtracker}"
dailydir="${dir}/${today}"

screenint="${SCREENINT:-30}"
quality="${QUALITY:-10}"

if [ ! -d "${dailydir}" ]; then
    echo "Directory absent, creating: ${dailydir}"
    mkdir -p "${dailydir}"
fi

while true; do
    # Allow for pausing capture
    if [ ! -f /tmp/trackerpause ]; then
        ts=$(date +"%H%M%S")
        targetdir="${dailydir}/${ts}.jpeg"
        scrot -q "${quality}" -m -z -p "${targetdir}"
    fi
    sleep $screenint
done
