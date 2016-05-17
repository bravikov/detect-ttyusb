#!/bin/bash

# Скрипт для слежения за подключением/отключением устройств /dev/ttyUSB и /dev/ttyACM.
#
# Сайт проекта: https://github.com/bravikov/detect-ttyusb
#
# Зависимости:
#    inotify-tools (для наблюдения за изменениями вкаталоге /dev)
#    notify-send (для уведомлений на рабочем столе)
#
# С помощью утилиты из inotify-tools скрипт устанавливает слежение за каталогом /dev и в случае его изменения дает об этом знать. Если inotify-tools не установлен, то скрипт проверяет каталог /dev раз в секунду.
#
# Пример вывода:
#[01.01.2013 20:20:01] Подключено ttyUSB0
#[01.01.2013 20:20:05] Подключено ttyUSB1
#[01.01.2013 20:20:08] Отключено ttyUSB0
#[01.01.2013 20:20:10] Отключено ttyUSB1

DIR="/dev"

PREV_DEV_LIST=""
while [ 1 ]
do
    DEV_LIST="`ls \"$DIR\" | grep 'ttyUSB\|ttyACM'`"
    
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
            NOTIFY_SEND_SUMMARY="/dev/$DEV подключено"
            notify-send "$NOTIFY_SEND_SUMMARY"
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
            NOTIFY_SEND_SUMMARY="/dev/$PREV_DEV отключено"
            notify-send "$NOTIFY_SEND_SUMMARY"
        fi
    done
    ##############################
    
    PREV_DEV_LIST="$DEV_LIST"
    
    if [ -x "`which inotifywait`" ]
        then
            inotifywait -e create -e delete "$DIR" > /dev/null 2>&1
        else
            sleep 1
    fi
done

