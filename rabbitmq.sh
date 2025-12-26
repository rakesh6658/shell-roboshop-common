#!/bin/bash
source ./common.sh
check_root_user
cp /home/ec2-user/shell-roboshop-common/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo  &>>$log_file
validate $? "copying rabbitmq.repo"

dnf install rabbitmq-server -y &>>$log_file
validate $? "installing rabbitmq-server"

systemctl enable rabbitmq-server &>>$log_file
validate $? "enabling rabbitmq-server"

systemctl start rabbitmq-server &>>$log_file
validate $? "starting rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123 &>>$log_file
validate $? "adding user and password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
validate $? "setting permissions"
