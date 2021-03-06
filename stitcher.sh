#! /bin/bash
set -e

dir="${TARGETDIR:-~/prodtracker}"

# Settled on these after manual experimentation. Optimizing for size.
framerate=2
crf=19

function set_todays() {
    todays=$(date --date="today" +"%m%d%y")
}

function stitch() {
    targetdir=$1
    output="${targetdir}/summary.mp4"
    echo "Generating video for $targetdir"
    ffmpeg -r ${framerate} -f image2 -pattern_type glob -i "${targetdir}/*.jpeg" -vcodec libx264 -crf ${crf} ${output}
}

function clean() {
    targetdir=$1
    if [ $(find "${targetdir}" -name "*.jpeg" | wc -l) -gt 0 ]; then
        echo "Deleting *.jpeg files in ${targetdir}"
        rm ${targetdir}/*.jpeg
    fi
}

function main() {
    set_todays
    while true; do
        date_now=$(date --date="today" +"%m%d%y")
        if [ "${date_now}" != "${todays}" ]; then
            set_todays
        fi

        for d in $(find $dir -mindepth 1 -type d); do
            # Do not stitch or clean today's directory, only those from the past.
            if [ "${d: -6}" == "${todays}" ] ; then
                continue
            fi
            # Use summary.mp4 as a marker whether a directory has been processed or not.
            output_file="${d}/summary.mp4"
            if [ ! -f "${output_file}" ]; then
                stitch "${d}"
            fi
            clean "${d}"
        done
        # Re-run this loop every hour, so if you suspend your computer over night,
        # this will create a new video summary and clean up older files.
        sleep 3600
    done
}

main
