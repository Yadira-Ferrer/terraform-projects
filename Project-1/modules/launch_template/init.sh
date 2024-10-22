#!/bin/bash
yum install git -y
yum install nginx -y
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /usr/share/nginx/html/

service nginx start
chkconfig nginx on

sudo git clone https://github.com/Yadira-Ferrer/html-basic-page.git 
sudo cp html-basic-page/* /usr/share/nginx/html/ -R

