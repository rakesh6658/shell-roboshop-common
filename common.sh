#!/bin/bash
start_time=$(date +%s)
user_id=$(id -u)
check_root_user(){
if [ $user_id -ne 0 ]
then
echo "Do not have root access"
exit 1
fi
}
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
validate(){
if [ $1 -ne 0 ]
then
echo -e "$2 ... $RED failure $NC"
else
echo -e "$2 ...  $GREEN success $NC"
fi

}
LOG_DIR="/var/log/shell-roboshop"
script_name=$(echo "$0" | cut -d "." -f1)
log_file="$LOG_DIR/$script_name.log"
mkdir -p /var/log/shell-roboshop
print_total_time(){
    end_time=$(date +%s)
    total_time=$(($end_time-$start_time))
    echo "Time taken for executing script is $total_time seconds"
}
setup_nodejs(){
    dnf module disable nodejs -y &>>$log_file
validate $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>$log_file
validate $? "enabling nodejs"

dnf install nodejs -y &>>$log_file
validate $? "Installing nodejs"
}