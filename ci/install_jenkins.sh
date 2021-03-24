#! /bin/bash
yum update -y
yum install amazon-cloudwatch-agent -y
wget -O /cloudwatch.cfg https://vijay07122020.s3.eu-central-1.amazonaws.com/cloudwatch.cfg
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:cloudwatch.cfg
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins -y
yum install java-1.8.0-openjdk-devel -y
yum install ant -y
yum install git -y
cat /etc/init.d/jenkins | sed /.*\\/etc\\/init\\.d\\/functions/a\ 'export PATH="/usr/local/bin:/usr/bin:$PATH"'
# systemctl daemon-reload
service jenkins restart