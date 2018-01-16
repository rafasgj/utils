#!/bin/sh

file=$1
shift

output=$1
shift

tmp=/tmp/`basename ${file}`

sz=`identify ${file} | cut -d" " -f3`
w=`echo ${sz} | cut -dx -f1`
h=`echo ${sz} | cut -dx -f2`

if [ $h -gt 1080 ]
then
    convert ${file} -resize x1080 -gravity center -format jpg $tmp
    file=$tmp
    sz=`identify ${file} | cut -d" " -f3`
    w=`echo ${sz} | cut -dx -f1`
    h=`echo ${sz} | cut -dx -f2`
fi 

slices=`echo "print $w/$h" | python`

max_w=$[$slices * 1080]

if [ $max_w -lt $w ]
then
    tmp=/tmp/tmp-`basename ${file}`
    convert ${file} -resize ${max_w}x${h} -background white -gravity center -extent ${max_w}x${h} -format jpg -quality 100 $tmp
    file=$tmp
fi

convert ${file} -crop `echo "print(100.0/$slices)" | python`%x100% +repage $output.jpg

