#!/bin/sh

file=$1
shift

output=$1
shift

sz=`identify ${file} | cut -d" " -f3`

w=`echo ${sz} | cut -dx -f1`
h=`echo ${sz} | cut -dx -f2`

slice=`echo "print (100.0/($w/1080))" | python`

convert $file -crop ${slice}%x100% +repage $output.jpg
