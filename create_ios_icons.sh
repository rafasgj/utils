#!/bin/sh

filename=$1
shift

ext=`echo ${filename} | awk -F. '{ print $NF }' `
file=`basename ${filename} .${ext}`

sizes=(512 180 152 120 120 87 80 76 58 40 29)
names=("iTunesArtwork" "icon-60-3x" "icon-76-2x" "icon-60-2x" "icon-small-40-3x" "icon-small-3x" "icon-small-40-2x" "icon-76" "icon-small-2x" "icon-small-40" "icon-small")

for i in `seq 0 $[${#sizes[*]} - 1]`
do
    sz=${sizes[i]}
    tgt="${file}-${names[i]}-${sz}x${sz}.${ext}"
    convert "${filename}" -monitor -resize "${sz}x${sz}" "${tgt}"
done
