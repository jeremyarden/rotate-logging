#!/bin/bash

file_name=$1
log_size=$2
current_date=$(date +'%m-%d-%Y')
file_size=$(stat -f %z "$file_name")

rotate() {
    getLatestVer

    echo $latest

    if [ "$file_size" -ge "$log_size" ]
    then
        case ${latest_ver} in
        "")
            echo "null situation"
            zip -v "${file_name%%.*}-${current_date}".zip "$file_name"
            ;;
        zip)
            echo "zip situation"
            mv "${file_name%%.*}-${current_date}".zip "${file_name%%.*}-${current_date}".zip.1
            zip -v "${file_name%%.*}-${current_date}".zip.2 "$file_name"
            ;;
        [1-9]*)
            echo "${latest_ver} situation"
            latest_ver=$((latest_ver + 1))
            zip -v "${file_name%%.*}-${current_date}".zip."${latest_ver}" "$file_name"
            ;;
        esac
    fi
}

getLatestVer() {
    latest=$(ls -tr "${file_name%%.*}-${current_date}".zip* | tail -n 1)
    latest_ver=${latest##*.}
    echo ${latest##*.}
}

rotate
