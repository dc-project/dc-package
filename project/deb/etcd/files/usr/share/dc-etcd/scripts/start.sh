#!/bin/sh
LOCAL_NODE=$(hostname -s)

INITIAL_CLUSTER_STATE=""

if [ -z $LOCAL_IP ];then
	echo "find ip address failed" > /dev/stderr
	echo "need define LOCAL_IP" >/dev/stderr
	exit 1
fi

##
# NODES="
# $LOCAL_NODE:${LOCAL_IP:-127.0.0.1}
# node1:192.168.100.1
# node2:192.168.100.2
# "
##
NODES="
$LOCAL_NODE:$LOCAL_IP
"

INITIAL_CLUSTER=""

LOCAL_NODE_COUNT=$(echo $NODES | tr " " "\n" | sort -u | grep $LOCAL_NODE | wc -l)
if [ $LOCAL_NODE_COUNT -ne 1 ];then
	echo "NODES contains $LOCAL_NODE_COUNT different nodes: $LOCAL_NODE" > /dev/stderr
	exit 1
fi

for node in $(echo $NODES | tr " " "\n" | sort -u)
do
	NAME=${node%%:*}
	IP=${node#*:}
	member="$NAME=http://$IP:2380"
	if [ -z $INITIAL_CLUSTER ];then
		INITIAL_CLUSTER=$member
	else
		INITIAL_CLUSTER="$INITIAL_CLUSTER,$member"
	fi
done

#echo $INITIAL_CLUSTER
ETCD_OPTS="-name $LOCAL_NODE -initial-advertise-peer-urls http://$LOCAL_IP:2380
-listen-peer-urls http://$LOCAL_IP:2380
-initial-cluster-token etcd-cluster
-initial-cluster $INITIAL_CLUSTER
-initial-cluster-state ${INITIAL_CLUSTER_STATE:-new}
-data-dir /data/etcd/
-advertise-client-urls http://$LOCAL_IP:4001,http://$LOCAL_IP:2379
-listen-client-urls http://127.0.0.1:4001,http://127.0.0.1:2379,http://$LOCAL_IP:4001,http://$LOCAL_IP:2379
"
exec /usr/bin/etcd $ETCD_OPTS