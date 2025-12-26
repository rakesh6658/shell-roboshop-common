#!/bin/bash
source ./common.sh
check_root_user
application=shipping
installing_maven
app_setup
deamon_reload
dnf install mysql -y &>>$log_file
validate $? "installing mysql client"

mysql -h mysql.joindevops.store -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log_file
validate $? "loading schema"

mysql -h mysql.joindevops.store -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log_file
validate $? "creating app-user"

mysql -h mysql.joindevops.store -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log_file
validate $? "loading master data"
restarting