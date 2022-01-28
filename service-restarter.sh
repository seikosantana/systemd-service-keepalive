#!/bin/bash

if [[ -z "$1" ]] ; then
    echo 'Service name is not specified'
    exit 1
fi

delay=5

if [[ -z "$2" ]] ; then
    echo 'Delay is not specified, defaulting to 5 seconds'
    delay=5
fi

while :
do
    systemctl restart $1 &
    sleep $delay
done
