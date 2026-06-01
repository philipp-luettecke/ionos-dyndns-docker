#!/bin/bash

log() {
    local log_level=$1  # A string representing the log level provided by the user when calling the function
    local message=$2  # A string representing the message provided by the user when calling the function
    local script_name=$(basename $0)  # The name of the script that is running
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")  # The current date and time at the time the function is called
    echo "$timestamp [$log_level] [$script_name] $message" | tee -a $LOGFILE
}

if [[ -z "${FILENAME_SETTINGS}" ]]; then
    FILENAME_SETTINGS=settings.txt
    log "INFO" "No FILENAME_SETTINGS provided. Using default."
fi

export SETTINGS_PATH=/config/$FILENAME_SETTINGS

if [[ -f $SETTINGS_PATH ]]; then
    log "INFO" "Using $SETTINGS_PATH"
else
    log "WARN" "Settings file $SETTINGS_PATH is not found. Creating settings.txt file."
    touch $SETTINGS_PATH
fi

log "INFO" "Everything seems to be fine now; I will update all configured domains every $UPDATE_INTERVAL minutes"

while true
do 
    log "INFO" "Updating all configured DynDNS domains"
    domain-connect-dyndns update --all --config $SETTINGS_PATH
    sleep $(($UPDATE_INTERVAL*60))
done