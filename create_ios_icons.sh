#!/bin/sh

filename=$1
shift

bg='transparent'
[ -z "$1" ] || bg="$1"

ext=`echo ${filename} | awk -F. '{ print $NF }' `
file=`basename ${filename} .${ext}`

sizes=(512 180 167 152 120 120 87 80 60 76 58 40 29 20)

for i in `seq 0 $[${#sizes[*]} - 1]`
do
    sz=${sizes[i]}
    tgt="${file}-${sz}.${ext}"
    convert "${filename}" -monitor -resize "${sz}x${sz}" tmp.png
    convert tmp.png -gravity center -background "${bg}" -extent "${sz}x${sz}" "${tgt}"
    rm tmp.png
done
