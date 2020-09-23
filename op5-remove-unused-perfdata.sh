#!/bin/bash

# "THE BEER-WARE LICENSE" - - - - - - - - - - - - - - - - - -
# This file was initially written by Robert Claesson.
# As long as you retain this notice you can do whatever you
# want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# - - - - - - - - - - - - - - - robert.claesson@gmail.com - -

# Make sure Livestatus is running.
if ! mon query ls hosts -c name >> /dev/null
then
	echo "Could not talk to Livestatus. Exiting."
	exit 1
fi

# Loop through perfdata, delete not matching hosts
cd /opt/monitor/op5/pnp/perfdata/  || exit 1
for host_folder in *
do
	host_folder="${host_folder//_/ }"
	if [ -d "$host_folder" ]
	then
		host_exist=$(mon query ls hosts -c name name -e "$host_folder")
		if [ -z "$host_exist" ]
		then
			echo "Deleting: $host_folder"
			rm -fr "$host_folder"
		fi
		host_exist=""
	fi
done
