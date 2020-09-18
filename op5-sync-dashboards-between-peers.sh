#!/bin/bash

# "THE BEER-WARE LICENSE" - - - - - - - - - - - - - - - - - -
# This file was initially written by Robert Claesson.
# As long as you retain this notice you can do whatever you
# want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# - - - - - - - - - - - - - - - robert.claesson@gmail.com - -


# Description:
#       Sync dashboards from one peer to all other peers.
#       Should run on the peer with active GUI users.
#       Recommended to run as user monitor.
#

# Binaries
mysql=$(command -v mysql)
mysqldump=$(command -v mysqldump)
scp=$(command -v scp)
ssh=$(command -v ssh)

# Files & dirs
tmpdir="/tmp"
table_dashboards="merlin.dashboards.sql"
table_dashboards_widgets="merlin.dashboard_widgets.sql"
table_saved_filters="merlin.ninja_saved_filters.sql"

# Check root privileges
if [ $EUID -ne 299 ]
then
        echo "Script must run as user monitor. Exiting."
        exit 1
fi

# Get all peers, exclude the one we run from
peers=$(mon node list --type=peer | cut -d' ' -f3)

# Dump current dashboard tables
$mysqldump -u root merlin dashboards > "${tmpdir}"/"${table_dashboards}"
$mysqldump -u root merlin dashboard_widgets > "${tmpdir}"/"${table_dashboards_widgets}"
$mysqldump -u root merlin ninja_saved_filters > "${tmpdir}"/"${table_saved_filters}"

# Send & import to other peer(s)
for peer in $peers
do
        $scp "${tmpdir}"/"${table_dashboards}" "${tmpdir}"/"${table_dashboards_widgets}" "${tmpdir}"/"${table_saved_filters}" "$peer":"${tmpdir}"
        $ssh "$peer" "$mysql -u root merlin < ${tmpdir}/${table_dashboards}"
        $ssh "$peer" "$mysql -u root merlin < ${tmpdir}/${table_dashboards_widgets}"
        $ssh "$peer" "$mysql -u root merlin < ${tmpdir}/${table_saved_filters}"
done

# Done
exit 0
