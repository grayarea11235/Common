#!/bin/bash
#lockkey.sh

sleep .2

case $1 in
    'num')
        mask=2
        key="Num"
        ;;
    'caps')
        mask=1
        key="Caps"
        ;;
esac

value="$(xset q | grep 'LED mask' | awk '{ print $NF }')"

if [ $(( 0x$value & 0x$mask )) == $mask ]
then
    output="$key on"
else
    output="$key off"
fi

echo $output
#notify-send "$output"
