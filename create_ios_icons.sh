#!/bin/sh

usage() {
    echo "Usage: create_ios_icons.sh [-b <bgcolor>] [-t] [-h] imagefile"
    echo "\t-b <bgcolor>"
    echo "\t\tSet the background color (default: transparent)."
    echo "\t-t"
    echo "\t\tGenerate binary icons for Tab Bar. Default bg is white."
    echo "\t-h"
    echo "\t\tShows this help screen."
    exit $1
}

args=`getopt "htb:"   $*`
[ $? -ne 0 ] && usage 1

set -- $args

sizes=(512 180 167 152 120 120 87 80 60 76 58 40 29 20)
extra=""
gray="no"
bg='transparent'

for opt
do
    case "$opt" in
        -h) usage 0
            ;;
        -t) sizes=(75 50 25)
            extra="-tabicon"
            gray="yes"
            [ "${bg}" == "transparent" ] & bg="white"
            ;;
        -b) bg="$2"
            ;;
        "--") shift
            break
            ;;
    esac # is ridiculous
    shift
done

filename="$1"
shift

[ -z "${filename}" -o "${filename}" == "--" ] && usage 1 

ext=`echo ${filename} | awk -F. '{ print $NF }' `
file=`basename ${filename} .${ext}`

#echo "[$filename] [$ext] [$file] [$bg] [$gray] [$extra]"
#exit

mkdir "$file" 2>/dev/null

source="$filename"
if [ "${gray}" == "yes" ]
then
    source="/tmp/gray.png"
    convert "${filename}" -background "${bg}" -alpha remove -set colorspace Gray -separate -average "${source}"
fi

for i in `seq 0 $[${#sizes[*]} - 1]`
do
    sz=${sizes[i]}
    tgt="${file}/${file}-${sz}${extra}.${ext}"
    convert "${source}" -monitor -resize "${sz}x${sz}" /tmp/tmp.png
    convert /tmp/tmp.png -gravity center -background "${bg}" -extent "${sz}x${sz}" "${tgt}"
    rm /tmp/tmp.png
done

[ "${source}" != "${filename}" ] && rm "${source}"

