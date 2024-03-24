#!/bin/bash

if [[ -z "${FILENAME_SETTINGS}" ]]; then
    FILENAME_SETTINGS=settings.txt
    echo $(date -R) "No FILENAME_SETTINGS provided. Using default."
fi

export SETTINGS_PATH=/config/$FILENAME_SETTINGS

if [[ -f $SETTINGS_PATH ]]; then
    echo $(date -R) "Using $SETTINGS_PATH"
else
    echo $(date -R) "Settings file $SETTINGS_PATH is not found. Creating settings.txt file."
    touch $SETTINGS_PATH
fi

echo $(date -R) "Everything seems to be fine now; I will update all configured domains every $UPDATE_INTERVAL minutes"

while true
do 
    echo $(date -R) "Updating all configured DynDNS domains"
    domain-connect-dyndns update --all --config $SETTINGS_PATH
    sleep $(($UPDATE_INTERVAL*60))
done