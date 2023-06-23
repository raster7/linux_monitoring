#!/bin/bash

if [[ -z $1 ]]; then
    echo "Error: You should pass the path" >&2;
    exit 1;
elif (( $# > 1 )); then
    echo "Error: You must pass only 1 param and no more" >&2;
    exit 1;
elif [[ ! $1 =~ /$ ]]; then
    echo "Error: The path should end with \"/\"" >&2;
    exit 1;
elif [ ! -d "$1" ]; then
    echo "Directory $1 does not exists" >&2;
    exit 1;
fi

START_POINT=$(date +%s%N)

FOLDERS_NUM=$(ls -laR $1 | grep -c "^d");
FILES_NUM=$(ls -laR $1 | grep -c "^-");

echo "Total number of folders (including all nested ones) = $FOLDERS_NUM"; 
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"; 
echo -en $(du -Sh $1 | sort -nr | head -n 5 | awk '{printf "%d - %s, %s\\n", NR-0, $2, $1}');
echo "Total number of files = $FILES_NUM";
echo "Number of:"
echo "Configuration files (with the .conf extension) = $(ls -laR $1 | grep -c ".conf$")";
echo "Text files = $(ls -laR $1 | grep -c ".txt$")";
echo "Executable files = $(find $1 -executable -type f | wc -l)";
echo "Log files (with the extension .log) = $(ls -laR $1 | grep -c ".log$")"; 
echo "Archive files = $(ls -laR $1 . | grep -Poc ".zip$|.rar$|.tar$")";
echo "Symbolic links = $(ls -laR $1 | grep -c "^l")";
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"  
echo -en $(find $1 -type f -exec du -Sh {} + | sort -rh | head -n 10 |
        awk '{printf "%d - %s, %s, ", NR-0, $2, $1;
        len=split($2, a, "."); printf "%s\\n", a[len]}'); 
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
echo -en $(find $1 -type f -executable -exec du -Sh {} + | sort -rh | head -n 10 |
        awk '{printf "%d - %s, %s, ", NR-0, $2, $1; sha="md5sum "$2;
        sha | getline tmp; close(sha); hash=split(tmp, a, " "); printf "%s\\n", a[1]}');

END_POINT=$(date +%s%N)
DIFF=$(bc -l <<< "scale=1; ($END_POINT - $START_POINT)/1000000000");

echo "Script execution time (in seconds) = $DIFF";
