#!/bin/sh

NAME="`basename "$1"`"

hdiutil makehybrid -iso -joliet -default-volume-name "$NAME" -o "${HOME}/Desktop/${NAME}.iso" "$1"
