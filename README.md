# op5-monitor-toolbox

## op5-configure-selinux
ITRS OP5 Monitor disables SELinux at installation. This scripts create SELinux-rules that allows SELinux to be enabled while running ITRS OP5 Monitor.

In /etc/selinux/config and set SELINUX=enforcing
To make all files & folders to get the correct selinux-context, create the file /.autorelabel and reboot to initialize it.
```
touch /.autorelabel
reboot
```

After reboot, run script:
```
./op5-configure-selinux.sh
```

## op5-remove-unused-perfdata
ITRS OP5 Monitor never deletes performance data about hosts & services. Even if objects are removed from object config.
To remove performance data from hosts/services that does not exist in object configuration, run script:
```
./op5-remove-unused-perfdata.sh
```

## op5-sync-dashboards-between-peers
In peered environments, it could be useful to have the same dashboard for all users. Since ITRS OP5 Monitor does not sync dashboard.
```
./op5-sync-dashboards-between-peers.sh
```
