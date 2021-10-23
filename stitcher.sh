#! /bin/bash

dir="${TARGETDIR:-~/prodtracker}"
yesterday=$(date --date="yesterday" +"%m%d%y")
targetdir="${dir}/${yesterday}"
output="${targetdir}/summary.mp4"

framerate=2
crf=25

if [ ! -d "${targetdir}" ]; then
    echo "${targetdir} doesn't exist"
    exit 1
fi

if [ -f "${output}" ]; then
    echo "${output} already exists! Bye!"
    exit 0
fi


ffmpeg -r ${framerate} -f image2 -pattern_type glob -i "${targetdir}/*.png" -vcodec libx264 -crf ${crf} ${output}
