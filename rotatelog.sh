#!/bin/bash

if ! zip_loc="$(type -p zip)" || [[ -z $zip_loc ]]
then
    DISTRO=$(cat /etc/*release | grep '^ID=' | grep -o '".*"' | sed 's/"//g')

    if [ $DISTRO == "ubuntu" ] || [ $DISTRO == "debian" ] || [ $DISTRO == "linuxmint" ]
    then
        sudo apt install zip
    elif [ $DISTRO == "rhel" ] || [ $DISTRO == "fedora" ] || [ $DISTRO == "centos" ]
    then
        sudo dnf install zip
    elif [ $DISTRO == "arch" ] ||  [ $DISTRO == "manjaro" ]
    then
        sudo pacman -S zip
    else
        echo "Distro unknown. Please install zip"
    fi
fi

if [ -z $1 ]
then
    echo "Please enter log path"
    exit 1
fi

if [ ! -e $1 ]
then
    echo "Path not found!"
    exit 1
fi

file_name=$(realpath $1)

log_size=$2

if [ -z $2 ]
then
    log_size=50
fi

current_date=$(date +'%m-%d-%Y')
file_size=$(($(stat -f %z "$file_name")/1000000))
current_time=$(date +'%H:%M:%S')

removeFileOlderThan() {
    find $(dirname ${file_name}) -mtime +30 -exec rm {} \;
}

getLatestVer() {
    latest=$(ls -tr "${file_name%%.*}-${current_date}".zip* | tail -n 1)
    latest_ver=${latest##*.}
}

rotate() {
    removeFileOlderThan
    getLatestVer

    if [ "$file_size" -ge "$log_size" ] || [ "$current_time" == "00:05:00" ]
    then
        local temp_filename="${file_name%%.*}-${current_date}-${current_time}.${file_name##*.}"
        case ${latest_ver} in
        "")
            mv ${file_name} ${temp_filename} && touch ${file_name}
            zip -v "${file_name%%.*}-${current_date}".zip $temp_filename
            rm "$temp_filename"
            ;;
        zip)
            mv ${file_name} ${temp_filename} && touch ${file_name}
            mv "${file_name%%.*}-${current_date}".zip "${file_name%%.*}-${current_date}".zip.1
            zip -v "${file_name%%.*}-${current_date}".zip.2 "$temp_filename"
            rm "$temp_filename"
            ;;
        [1-9]*)
            latest_ver=$((latest_ver + 1))
            mv ${file_name} ${temp_filename} && touch ${file_name}
            zip -v "${file_name%%.*}-${current_date}".zip."${latest_ver}" "$temp_filename"
            rm "$temp_filename"
            ;;
        *)
            echo "Unknown format"
            ;;
        esac
    fi
}

rotate