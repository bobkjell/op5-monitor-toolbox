#!/bin/bash

# "THE BEER-WARE LICENSE" - - - - - - - - - - - - - - - - - -
# This file was initially written by Robert Claesson.
# As long as you retain this notice you can do whatever you
# want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# - - - - - - - - - - - - - - - robert.claesson@gmail.com - -

# Install needed packages
yum install -y policycoreutils-python setroubleshoot

# Variables
monitor_path="/opt/monitor"
unconfined_type="bin_t"

# Disable all abrt services. OP5 requires these but they cause selinux errors.
abrt_services="abrt-ccpp.service abrtd.service abrt-oops.service abrt-pstoreoops.service abrt-vmcore.service abrt-xorg.service"
/usr/bin/systemctl disable $abrt_services &>/dev/null
/usr/bin/systemctl stop $abrt_services &>/dev/null
usr/bin/systemctl mask $abrt_services &>/dev/null

# Set file contexts
echo "Setting file contexts..."
# Run http unconfined, since Nacoma lives in the http context.
semanage fcontext -a -t $unconfined_type /usr/sbin/httpd
restorecon /usr/sbin/httpd
# Run snmpd unconfined - To allow OP5 self monitoring.
semanage fcontext -a -t $unconfined_type /usr/sbin/snmpd
restorecon /usr/sbin/snmpd
# Run smsd unconfined
semanage fcontext -a -t $unconfined_type /usr/sbin/smsd
restorecon /usr/sbin/smsd

semanage fcontext -a -t ssh_home_t "${monitor_path}/.ssh(/.*)?"
semanage fcontext -a -t var_log_t  "${monitor_path}/var"
semanage fcontext -a -t var_log_t  "${monitor_path}/var/naemon.log"
semanage fcontext -a -t var_log_t  "${monitor_path}/var/archives(/.*)?"
semanage fcontext -a -t var_run_t  "${monitor_path}/var/rw(/.*)?"
semanage fcontext -a -t var_run_t  "/var/cache/naemon(/.*)?"
semanage fcontext -a -t etc_t      "${monitor_path}/op5/merlin/merlin.conf"
semanage fcontext -a -t etc_t      "${monitor_path}/etc(/.*)?"
restorecon -R ${monitor_path}/var
restorecon -R ${monitor_path}/.ssh
restorecon -R ${monitor_path}/op5/merlin
restorecon -R ${monitor_path}/etc
restorecon -R /var/cache/naemon

# Done
echo "Done"
