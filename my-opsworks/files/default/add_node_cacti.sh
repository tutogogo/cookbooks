#!/bin/bash

nodename=$1
SVR_NAME=${nodename}

cd /var/lib/cacti/cli
# Add new node to cacti
echo -e "Add node ${nodename} to cacti \n" 
sudo php add_device.php --description="${nodename}" --ip="${SVR_NAME}" --template="3" --version="2" --community="dolibarr" --avail="snmp"
echo -e "CR=$?\n" 
sleep 2


# Gest new node id
NODE_ID=`sudo php remove_device.php --list-devices | grep ${SVR_NAME} | awk '{ print $1 }'`


# Add graph Load Average
echo -e  "Add graph Load Average to node ${nodename}\n" 
php add_graphs.php  --graph-type=cg --host-id=$NODE_ID --graph-template-id=11
echo -e "CR=$?\n" 
sleep 2

# Add graph Memory Usage
echo -e  "Add graph Memory Usage to node ${nodename}\n" 
php add_graphs.php  --graph-type=cg --host-id=$NODE_ID --graph-template-id=13
echo -e "CR=$?\n" 
sleep 2

# Add graph CPU Usage
echo -e  "Add graph CPU Usage to node ${nodename}\n" 
php add_graphs.php  --graph-type=cg --host-id=$NODE_ID --graph-template-id=4
echo -e "CR=$?\n" 
sleep 2

# Add graph Template Statistic Interface to node
echo -e "Add graph Template Interface - Traffic (bits/sec) to node ${nodename}\n" 
sudo php add_graph_template.php --graph-template-id=2 --host-id=$NODE_ID
echo -e "CR=$?\n" 
sleep 2

# Add graph Statistic Interface eth0 (bis/s) to tree
echo -e  "Add Data Query SNMP - Interface STatistic  eth0 (bis/s) to node ${nodename} \n" 
sudo php add_graphs.php --host-id=$NODE_ID --graph-type=ds --graph-template-id=2 --snmp-query-id=1 --snmp-query-type-id=13 --snmp-field=ifName --snmp-value="eth0"
echo -e "CR=$?\n" 
sleep 2

# Disk I/O bytes/s
#echo -e $BLANCLAIR "Add graph Template Disk IO - Bytes per Second to node ${nodename}\n" $NORMAL
#sudo php add_graph_template.php  --graph-template-id=35 --host-id=$NODE_ID
#echo -e $JAUNE "CR=$?\n" $NORMAL
# Add Data Query
#echo -e $BLANCLAIR "Add Data Query SNMP - Get Disk IO to node ${nodename} \n" $NORMAL
#sudo php add_graphs.php --host-id=$NODE_ID --graph-type=ds --graph-template-id=35 --snmp-query-id=10 --snmp-query-type-id=23 --snmp-field=hrDiskIODescr --snmp-value=xvda1
#echo -e $JAUNE "CR=$?\n" $NORMAL


# Add node to tree "Environnement dolibarr"
echo -e "Add node ${nodename} to default tree \n" 
sudo php add_tree.php --type=node --node-type=host --tree-id=1 --host-id=$NODE_ID
echo -e "CR=$?\n" 
