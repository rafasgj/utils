#!/bin/sh

filename=$1
shift

ext=`echo ${filename} | awk -F. '{ print $NF }' `
file=`basename ${filename} .${ext}`

sizes=(512 180 167 152 120 120 87 80 76 58 40 29 20)

for i in `seq 0 $[${#sizes[*]} - 1]`
do
    sz=${sizes[i]}
    tgt="${file}-${sz}.${ext}"
    convert "${filename}" -monitor -resize "${sz}x${sz}" "${tgt}"
done
