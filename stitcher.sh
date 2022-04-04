#! /bin/bash
set -e

dir="${TARGETDIR:-$HOME/prodtracker}"

# Settled on these after manual experimentation. Optimizing for size.
framerate=2
crf=19

function set_todays() {
    todays=$(date +"%m%d%y")
}

#List all monitor names that were used in dir
function get_monitor_names() { 
  d="$1"
  ls $d | tr '_\.' ' ' | cut -d' ' -f2 | sort | uniq
}

function stitch() {
    targetdir="$1"
    monitor_name="$2"
    output_file="${targetdir}/summary_${monitor_name}.mp4"
    echo "Generating video(s) for $monitor_name in $targetdir: $output_file"
    ffmpeg -r ${framerate} -f image2 -pattern_type glob -i "${targetdir}/*_${monitor_name}.jpg" -vcodec libx264 -crf ${crf} ${output_file}
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
        date_now=$(date +"%m%d%y")
        if [ "${date_now}" != "${todays}" ]; then
            set_todays
        fi
        
        for d in $(find $dir -mindepth 1 -type d); do
            # Do not stitch or clean today's directory, only those from the past.
            if [ "${d: -6}" == "${todays}" ] ; then
                continue
            fi
            #function is only evaluated at the start
            for monitor_name in $(get_monitor_names); do
              # Use summary.mp4 as a marker whether a directory has been processed or not.
              output_file="${targetdir}/summary_${monitor_name}.mp4"
              if [ ! -f "${output_file}" ]; then
                  echo starting $output_file
                  stitch "${d}" "$monitor_name"
              fi
            done
            clean "${d}"
        done
        # Re-run this loop every hour, so if you suspend your computer over night,
        # this will create a new video summary and clean up older files.
        sleep 3600
    done
}

main
