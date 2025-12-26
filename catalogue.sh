#!/bin/bash

source ./common.sh
application=catalogue
check_root_user
setup_nodejs
app_setup
deamon_reload
cp /home/ec2-user/shell-roboshop-common/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying mongo.repo"

dnf install mongodb-mongosh -y &>>$log_file
validate $? "installing mongosh"

INDEX=$(mongosh mongodb.joindevops.store --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')") &>>$log_file
if [ $INDEX -le 0 ]
then
mongosh --host mongodb.joindevops.store </app/db/master-data.js
else
echo "Catalogue products already loaded"
fi
restarting
print_total_time

