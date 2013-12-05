#!/bin/bash

# Скрипт для слежения за подключением/отключением устройств ttyUSB*
# автор: bravikov@gmail.com

# Пример вывода:
#[01.01.2013 20:20:01] Подключено ttyUSB0
#[01.01.2013 20:20:05] Подключено ttyUSB1
#[01.01.2013 20:20:08] Отключено ttyUSB0
#[01.01.2013 20:20:10] Отключено ttyUSB1

PREV_DEV_LIST=""
while [ 1 ]
do
    DEV_LIST="`ls /dev | grep ttyUSB`"
    
    ##### find new device #####
    for DEV in $DEV_LIST
    do
        NEW_DEV=yes
        
        for PREV_DEV in $PREV_DEV_LIST
        do
            if [ "$DEV" == "$PREV_DEV" ]
            then
                NEW_DEV=no
                break
            fi
        done
        
        if [ $NEW_DEV == yes ]
        then
            echo [`date "+%x %X"`] Подключено $DEV
        fi
    done
    ###########################
    
    ##### find remote device #####
    for PREV_DEV in $PREV_DEV_LIST
    do
        REMOTE_DEV=yes
        
        for DEV in $DEV_LIST
        do
            if [ "$DEV" == "$PREV_DEV" ]
            then
                REMOTE_DEV=no
                break
            fi
        done
        
        if [ $REMOTE_DEV == yes ]
        then
            echo [`date "+%x %X"`] Отключено $PREV_DEV
        fi
    done
    ##############################
    
    PREV_DEV_LIST="$DEV_LIST"
    
    sleep 1
    
done

