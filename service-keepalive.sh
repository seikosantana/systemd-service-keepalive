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
    echo "Getting status of $1"
    status=$(systemctl is-active $1)
    echo "Service is $status";

    if [[ ! ( $status == "active" || $status == "activating" ) ]]; then
        echo "Starting service"
        systemctl start $1 &
    fi

    sleep $delay
done
