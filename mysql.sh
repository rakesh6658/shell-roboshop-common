#!/bin/bash
source ./common.sh
check_root_user
dnf install mysql-server -y &>>$log_file
validate $? "installing mysql"

systemctl enable mysqld &>>$log_file
validate $? "enabling mysqld"

systemctl start mysqld &>>$log_file
validate $? "starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
validate $? "mysql secure installation setting password"