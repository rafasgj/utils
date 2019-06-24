#!/bin/sh

png="$1"
shift 1

iconset="`basename ${png} .png`.iconset"

mkdir ${iconset}

for sz in 16 32 128 256 512
do
    sips -z ${sz} ${sz} "${png}" --out "${iconset}/icon_${sz}x${sz}.png"
done

for sz in 16 32 128 256 512
do
    sips -z $[2 * ${sz}] $[ 2 * ${sz}]t "${png}" --out "${iconset}/icon_${sz}x${sz}@2x.png"
done

iconutil -c icns "${iconset}"

