#!/bin/bash

# Require https://aur.archlinux.org/packages/libnotify-id/

chooseIcon() {
    MUTE=`amixer -c $CARD_NUM get $VOL_SET | grep -ce "\[off\]"`
    if [[ $MUTE -ne 0 ]]; then
        echo "stock_volume-mute"
    fi
    
    if (( $1 == 0 )); then
        echo "stock_volume-0"
    elif (( $1 < 33 )); then
        echo "stock_volume-min"
    elif (( $1 < 66 )); then
        echo "stock_volume-med"
    elif (( $1 <= 100 )); then
        echo "stock_volume-max"
    fi
}

USB_HEADSET=`amixer -c 1 | grep -ce "Headphone"`
if [[ $USB_HEADSET == 1 ]]; then 
    CARD_NUM=1
    VOL_SET="'Headphone'"
else
    CARD_NUM=0
    VOL_SET="'Master'"
fi


case $1 in
up) 
    /usr/bin/amixer -q -c $CARD_NUM sset $VOL_SET 5%+
    ;;
down)
    /usr/bin/amixer -q -c $CARD_NUM sset $VOL_SET 5%-
    ;;
toggle)
    /usr/bin/amixer -q -c $CARD_NUM sset $VOL_SET toggle
    ;;    
esac


VOL=`amixer -c $CARD_NUM get $VOL_SET | grep -o -E "\[[0-9]*%\]" | sed 's/[^0-9]//g' |uniq`
ICON=$(chooseIcon $VOL)

ID=`cat .id`
${ID:=0}
ID=$(notify-send 'test' -t 100 -i $ICON -h int:value:$VOL -p -r $ID)

echo $ID > .id


