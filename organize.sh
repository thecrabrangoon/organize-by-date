#!/bin/bash

version=0.1.0

copy=0              # default is to move
source_dir=.        # default is current dir
target_dir=.        # default is current dir
filter=*            # default is all files
verbose=0
verb=Moving

usage() {
    echo "usage: organize.sh [-h] [--version] [-v] [-c] [-s SOURCE_DIR] [-t TARGET_DIR] [-f FILTER]"
    echo "  -v - verbose mode"
    echo "  -c - copy files (default is move)"
    echo "  -s - provide SOURCE_DIR (default is current directory)"
    echo "  -t - provide TARGET_DIR (default is current directory)"
    echo "  -f - provide FILTER (e.g., *docx) (default is all files)"
}

show_version() {
    echo "v${version}"
}

echo "Organized by Date"
echo "https://github.com/tehcrabrangoon/organize-by-date"
echo "Forked off https://github.com/YakDriver/organize-by-date"
echo "---------------------------------------------"
while [ "$1" != "" ]; do
  case $1 in
    -c | --copy )         copy=1
                          ;;  
    -v )                  verbose=1
                          ;;                            
    -s | --source )       shift
                          source_dir=$1
                          ;;  
    -t | --target )       shift
                          target_dir=$1
                          ;;
    -f | --filter )       shift
                          filter=$1
                          ;;                          
    --version )           show_version
                          exit 1
                          ;;
    -h | --help )         usage
                          exit 1
                          ;;
    * )                   ;;
  esac
  shift
done

if [ "${copy}" -eq "0" ]; then
    echo "Moving files"
else    
    echo "Copying files"
    verb="Copying"
fi
echo "Source: ${source_dir}, Target: ${target_dir}, Filter: ${filter}"

cd "${source_dir}"

regex="^([0-9]{4})([0-9]{2})([0-9]{2})_[0-9]{6}\.jpg$"

for file in *; do    
    if [ ! -f "${file}" ]; then
        continue
    fi

    [[ ${file} =~ ${regex} ]]

    year="${BASH_REMATCH[1]}"
    month="${BASH_REMATCH[2]}"
    day="${BASH_REMATCH[3]}"

    formatted_date="${month}.${day}.${year}"
    dest="${target_dir}/${formatted_date}"

    if [ ! -d "${dest}" ]; then
        mkdir "${dest}"
    fi

    if [ "${verbose}" -eq "1" ]; then
        echo "${verb} file ${file} to ${dest}"
    fi

    if [ "${copy}" -eq "0" ]; then
        mv -n ${file} "${dest}/${file}"
    else
        cp -p ${file} "${dest}/${file}"
    fi
    
done
