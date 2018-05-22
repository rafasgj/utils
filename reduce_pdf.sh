#!/bin/sh

tempapp=`which mktemp || which tempfile`

OPTIONS="-dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4"
QUALITY="-dPDFSETTINGS=/ebook"

while [ ! -z "$1" ]
do
    pdffile="$1"
    shift
    tmpfile=`${tempapp}`
    echo "Reducing: ${pdffile}"
    gs ${OPTIONS} ${QUALITY} -sOutputFile=${tmpfile} ${pdffile}
    mv ${tmpfile} ${pdffile}
done

