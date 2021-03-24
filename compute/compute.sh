#! /bin/bash
yum update -y
yum install amazon-cloudwatch-agent -y
wget -O /cloudwatch.cfg https://vijay07122020.s3.eu-central-1.amazonaws.com/cloudwatch.cfg
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:cloudwatch.cfg
yum install jenkins -y
yum install java-1.8.0-openjdk-devel -y
wget -O /apache-tomcat-4.1.40.tar.gz https://archive.apache.org/dist/tomcat/tomcat-4/v4.1.40/bin/apache-tomcat-4.1.40.tar.gz
mkdir /tomcat
tar -xf apache-tomcat-4.1.40.tar.gz -C /tomcat