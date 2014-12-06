#!/bin/bash
replication="0"
clusterDir="/Users/rvarma/cluster"
redistribFolder="/Users/rvarma/redis-3.0.0-rc1/src/"

if [[ $# -lt 1 ]]; then
    echo "Usage: makemycluster.sh nodes
        where   nodes: is the number of instances in the cluster"
    exit 1
fi
rm -rf $clusterDir
mkdir -p $clusterDir
cd $clusterDir
base=6999
upper=$(($base + $1))
str=$replication+" "
for ((p=7000; p<=$upper; p++)) do
    mkdir ./$p
    cd $p
    echo "port $p" >> redis.conf
	echo "cluster-enabled yes" >> redis.conf
	echo "cluster-config-file nodes.conf" >> redis.conf
	echo "cluster-node-timeout 5000" >> redis.conf
	echo "appendonly yes" >> redis.conf

    redis-server redis.conf &
    cd ..
    str+="127.0.0.1:$p "
done
cd $redistribFolder
./redis-trib.rb create --replicas $str
exit 0