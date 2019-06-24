#!/bin/sh

if [ $# -lt 2 ]
then
    echo "usage: convert_video.sh <filename> [<filename> ...]" 
    exit 1 
fi

mode=$1
shift

# macOS AppleScript requires full path.
CONV=/usr/local/bin/ffmpeg
case ${mode} in
    "prores")
        PARAMS="-profile:v 3 -c:a mp2"
    ;;
    "libx264")
        PARAMS="-preset ultrafast -tune film -c:a aac"
    ;;
    *)
        echo "Invalid codec - ${mode}" >&2
    ;;
esac  # is ridiculous ;-)

OPTS="-y -i @INPUT@ -vcodec ${mode} ${PARAMS} @OUTPUT@"


[ -f "${HOME}/.videoconv" ] && . "${HOME}/videoconv"

while [ ! -z "$1" ]
do
    infile="$1"
    shift
    outfile="${infile}.mov"
    EXEC="`echo $CONV $OPTS | sed "s#@INPUT@#${infile}#g;s#@OUTPUT@#${outfile}#g"`"
    $EXEC
done

