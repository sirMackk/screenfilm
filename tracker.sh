#! /bin/bash

today=$(date +"%m%d%y")

dir="${TARGETDIR:-~/prodtracker}"
dailydir="${dir}/${today}"

screenint="${SCREENINT:-30}"

if [ ! -d "${dailydir}" ]; then
    echo "Directory absent, creating: ${dailydir}"
    mkdir -p "${dailydir}"
fi

while true; do
    ts=$(date +"%H%M%S")
    targetdir="${dailydir}/${ts}.png"
    scrot -z -p "${targetdir}"
    sleep $screenint
done
