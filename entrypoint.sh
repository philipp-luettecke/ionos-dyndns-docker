#!/bin/bash

if [[ -z "${FILENAME_SETTINGS}" ]]; then
    FILENAME_SETTINGS=settings.txt
    echo "No FILENAME_SETTINGS provided. Using default."
fi

export SETTINGS_PATH=/config/$FILENAME_SETTINGS

if [[ -f $SETTINGS_PATH ]]; then
    echo "Using $SETTINGS_PATH"
else
    echo "Settings file $SETTINGS_PATH is not found. Creating settings.txt file."
    touch $SETTINGS_PATH
fi

echo "Everything seems to be fine now; I will update all configured domains every $UPDATE_INTERVAL minutes"

while true
do 
    echo "Updating all configured DynDNS domains"
    domain-connect-dyndns update --all --config $SETTINGS_PATH
    sleep $(($UPDATE_INTERVAL*60))
done