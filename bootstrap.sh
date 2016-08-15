#!/bin/bash

if [ ! -d "/hadoop/hdfs/cache/dfs/name/current" ]; then
    #initialize name node
    sudo -u hdfs hdfs namenode -format
fi

# When using service command it says "Failed to get D-Bus connection: Operation not permitted"
# There is 3 ways to work around this phenomenon.
# 1. Use /sbin/init and let the service start from it.
# 2. Run docker with --privileged option.
# 3. Avoid using service command and just use the daemon script directly
# And my choice is 3. because the feature provided in service command is not actually needed at this morment.

#service hadoop-hdfs-namenode start
/etc/rc3.d/S85hadoop-hdfs-namenode start

if [ $? -gt 0 ]; then
    echo "Starting daemon failed."
    exit 1
fi

/etc/rc3.d/S85hadoop-yarn-resourcemanager start

if [ $? -gt 0 ]; then
    echo "Starting daemon failed."
    exit 1
fi



CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
	: #NOP
	#service sshd stop
	#/usr/sbin/sshd -D -d
else
	echo "$*"
	/bin/bash -c "$*"
fi
