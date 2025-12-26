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
app_setup(){
id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
validate $? "Adding user roboshop"
else
echo "roboshop user already exists"
fi

mkdir -p /app &>>$log_file
validate $? "Creating app directory"

curl -o /tmp/"$application".zip https://roboshop-artifacts.s3.amazonaws.com/"$application"-v3.zip &>>$log_file
validate $? "downloading "$application" application"

cd /app &>>$log_file
validate $? "Changing to app directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/"$application".zip &>>$log_file
validate $? "unzipping in /tmp directory"

npm install &>>$log_file
validate $? "Installing dependencies"

cp /home/ec2-user/shell-roboshop-common/"$application".service  /etc/systemd/system/"$application".service &>>$log_file
validate $? "copying "$application".service"
}
app_setup_maven(){
    id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
validate $? "Adding user roboshop"
else
echo "roboshop user already exists"
fi

mkdir -p /app &>>$log_file
validate $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>>$log_file
validate $? "downloading shipping application"

cd /app &>>$log_file
validate $? "Changing to app directory"

rm -rf /app/*
validate $? "Removing existing code"

unzip /tmp/shipping.zip &>>$log_file
validate $? "unzipping in /tmp directory"

mvn clean package  &>>$log_file
validate $? "building java application"

mv target/shipping-1.0.jar "$application".jar  &>>$log_file
validate $? "renaming to "$application".jar"

cp /home/ec2-user/shell-roboshop-common/"$application".service  /etc/systemd/system/"$application".service &>>$log_file
validate $? "copying "$application".service"

}
deamon_reload(){
    systemctl daemon-reload &>>$log_file
validate $? "deamon reload"

systemctl enable "$application"  &>>$log_file
validate $? "enabling "$application""

systemctl start "$application"  &>>$log_file
validate $? "starting "$application""
}
restarting(){
    systemctl restart "$application"  &>>$log_file
validate $? "restarting "$application""
}
installing_maven(){
 dnf install maven -y &>>$log_file
validate $? "installing maven"
   
}