#!/bin/bash

file_name=$1
log_size=$2
current_date=$(date +'%m-%d-%Y')
file_size=$(stat -f %z "$file_name")

removeFileOlderThan() {
    find . -mtime +30 -exec rm {} \;
}

rotate() {
    getLatestVer

    if [ "$file_size" -ge "$log_size" ]
    then
        case ${latest_ver} in
        "")
            zip -v "${file_name%%.*}-${current_date}".zip "$file_name"
            ;;
        zip)
            mv "${file_name%%.*}-${current_date}".zip "${file_name%%.*}-${current_date}".zip.1
            zip -v "${file_name%%.*}-${current_date}".zip.2 "$file_name"
            ;;
        [1-9]*)
            latest_ver=$((latest_ver + 1))
            zip -v "${file_name%%.*}-${current_date}".zip."${latest_ver}" "$file_name"
            ;;
        esac
    fi
}

getLatestVer() {
    latest=$(ls -tr "${file_name%%.*}-${current_date}".zip* | tail -n 1)
    latest_ver=${latest##*.}
}

rotate
