#!/bin/bash

DNS_NAME=admin.tutogogo.com
HOSTEDZONEID=Z27JWWONYELZEE

DNSIP=$(host $DNS_NAME | awk '{ print $4 }')

NEWIP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cd /home/ec2-user

sed -i "s/DNSIP/${DNSIP}/g" MyChangeRecordsRequest.xml
sed -i "s/NEWIP/${NEWIP}/g" MyChangeRecordsRequest.xml

echo "Update $DNS_NAME IP @ $DNSIP => $NEWIP"

./dnscurl.pl --keyname my-aws-account -- -H "Content-Type: text/xml; charset=UTF-8" -X POST --upload-file ./MyChangeRecordsRequest.xml https://route53.amazonaws.com/2012-12-12/hostedzone/${HOSTEDZONEID}/rrset