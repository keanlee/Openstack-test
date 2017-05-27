#!/bin/bash
#The Dashboard (horizon) is a web interface that enables cloud administrators and users to manage various OpenStack resources and services.

#----------Test only -----

function dashboard(){

cat 1>&2 <<__EOF__
$MAGENTA==========================================================================
      Begin to deploy Dashboard on ${YELLOW}$(hostname)${NO_COLOR}${MAGENTA} which as controller node
==========================================================================
$NO_COLOR
__EOF__

echo $BLUE Install openstack-dashboard ... $NO_COLOR
yum install openstack-dashboard -y 1>/dev/null
debug "$?" "Install openstack-dashboard failed "

cp -f ./etc/dashboard/local_settings /etc/openstack-dashboard
sed -i "s/127.0.0.1/$MGMT_IP/g"  /etc/openstack-dashboard/local_settings
sed -i "s/controller/$MGMT_IP/g" /etc/openstack-dashboard/local_settings

systemctl restart httpd.service memcached.service  
debug "$?" "systemctl restart httpd.service memcached.service Failed "

echo $BLUE Create flavor for openstack user ...$NO_COLOR
openstack flavor create --id 0 --vcpus 1 --ram 1024 --disk 20  m1.nano
debug "$?"  "opnstack flavor create failed "

cat 1>&2 <<__EOF__
$GREEN=====================================================================================
       
      Congratulation you finished to deploy Dashboard on ${YELLOW}$(hostname)${NO_COLOR}${GREEN}
 
=====================================================================================
$NO_COLOR
__EOF__

}
dashboard 
