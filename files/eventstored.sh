#!/bin/sh
# `/sbin/setuser eventstore` runs the given command as the user `eventstore`.
# If you omit that part, the command will be run as root.
chdir $ES_HOME
exec /sbin/setuser eventstore ./clusternode --http-prefixes="http://*:2113/" >>/var/log/eventstore.log 2>&1
