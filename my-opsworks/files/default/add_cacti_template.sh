#!/bin/bash
#Check if template already installed

cd /var/lib/cacti/cli
php add_graph_template.php --list-graph-templates | grep "Device I/O - Bytes Read/Written"

if [[ $? -eq 0 ]]
then
echo "Device I/O - Bytes Read/Written already installed"
exit 0
fi

#Unzip
echo "Unzip template source file "
unzip /tmp/Cacti_Net-SNMP_DevIO_v3.1.zip -d /tmp
echo "Copy net-snmp_devio.xml file"
cp /tmp/net-snmp_devio.xml /usr/share/cacti/resource/snmp_queries/net-snmp_devio.xml
echo "Import TMPL files"
php import_template.php --filename=/tmp/net-snmp_devIO-BytesRW_graph_TMPL.xml  --with-template-rras
php import_template.php --filename=/tmp/net-snmp_devIO-LoadAVG_graph_TMPL.xml  --with-template-rras
php import_template.php --filename=/tmp/net-snmp_devIO-ReadsWrites_graph_TMPL.xml  --with-template-rras
php import_template.php --filename=/tmp/net-snmp_devIO-Data_query.xml --with-template-rras