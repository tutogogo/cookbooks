#!/bin/bash

VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"

nodename=$1
SVR_NAME=${nodename}

cd /var/lib/cacti/cli
# Add new node to cacti
echo -e $BLANCLAIR "Add node ${nodename} to cacti \n" $NORMAL
sudo php add_device.php --description="Serveur Web ${nodename}" --ip="${SVR_NAME}" --template="3" --version="2" --community="dolibarr" --avail="snmp"
echo -e $JAUNE "CR=$?\n" $NORMAL

# Gest new node id
NODE_ID=`sudo php remove_device.php --list-devices | grep ${SVR_NAME} | awk '{ print $1 }'`

# Add graph CPU Usage
echo -e $BLANCLAIR "Add graph CPU Usage to node ${nodename}\n" $NORMAL
php add_graphs.php  --graph-type=cg --host-id=$NODE_ID --graph-template-id=4
echo -e $JAUNE "CR=$?\n" $NORMAL

# Add graph Template Statistic Interface to node
echo -e $BLANCLAIR "Add graph Template Interface - Traffic (bits/sec) to node ${nodename}\n" $NORMAL
sudo php add_graph_template.php --graph-template-id=2 --host-id=$NODE_ID
echo -e $JAUNE "CR=$?\n" $NORMAL

# Add graph Statistic Interface eth0 (bis/s) to tree
echo -e $BLANCLAIR "Add Data Query SNMP - Interface STatistic  eth0 (bis/s) to node ${nodename} \n" $NORMAL
sudo php add_graphs.php --host-id=$NODE_ID --graph-type=ds --graph-template-id=2 --snmp-query-id=1 --snmp-query-type-id=13 --snmp-field=ifName --snmp-value="eth0"
echo -e $JAUNE "CR=$?\n" $NORMAL

# Disk I/O bytes/s
echo -e $BLANCLAIR "Add graph Template Disk IO - Bytes per Second to node ${nodename}\n" $NORMAL
sudo php add_graph_template.php  --graph-template-id=35 --host-id=$NODE_ID
echo -e $JAUNE "CR=$?\n" $NORMAL
# Add Data Query
echo -e $BLANCLAIR "Add Data Query SNMP - Get Disk IO to node ${nodename} \n" $NORMAL
sudo php add_graphs.php --host-id=$NODE_ID --graph-type=ds --graph-template-id=35 --snmp-query-id=10 --snmp-query-type-id=23 --snmp-field=hrDiskIODescr --snmp-value=xvda1
echo -e $JAUNE "CR=$?\n" $NORMAL


# Add node to tree "Environnement dolibarr"
echo -e $BLANCLAIR "Add node ${nodename} to tree Environnement dolibarr \n" $NORMAL
sudo php add_tree.php --type=node --node-type=host --tree-id=1 --host-id=$NODE_ID
echo -e $JAUNE "CR=$?\n" $NORMAL
