#!/bin/bash
wget http://120.96.143.10/get/getkc.conf -O getkc.conf &>/dev/null
[ $? != 0 ] && echo "download getkc.conf fail" && exit 1

source getkc.conf
NAMESPACE=$(ssh  ${UR}@${MAS_IP} "cat ${DIR_ROLE}nslist.txt | grep ${USER} | cut -d ':' -f 1")

[ ! -d studentweb ] && echo "'studentweb' is not exist ,mkdir this dir and put your 'index.html' into this directory." && exit 1
BUSYBOX_NODE=$(kubectl get pod -n ${NAMESPACE} -o wide |grep busybox| tr -s " "|cut -d " " -f7)
BUSYBOX_IP=$(echo $BUSYBOX_NODE | cut -d '-' -f1-4 | tr '-' '.' )
scp studentweb/* bigred@${BUSYBOX_IP}:/opt/pv/www
