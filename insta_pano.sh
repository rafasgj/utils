#!/bin/sh

file=$1
shift

output=$1
shift

sz=`identify ${file} | cut -d" " -f3`

w=`echo ${sz} | cut -dx -f1`
h=`echo ${sz} | cut -dx -f2`

slices=`echo "print $w/1080" | python`

max_w=$[$slices * 1080]

if [ $max_w -ne $w ]
then
    tmp=/tmp/`basename ${file}`
    convert ${file} -resize ${max_w}x${h} -background white -gravity center -extent ${max_w}x${h} -format jpg -quality 100 $tmp
    file=$tmp
fi

convert ${file} -crop `echo "print(100.0/$slices)" | python`%x100% +repage $output.jpg
