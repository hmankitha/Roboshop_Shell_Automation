#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.ankitha.online


if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
    else 
        echo -e "$2 ... $G SUCESS $N" | tee -a $LOGS_FILE
    fi    

}

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld &>>$LOGS_FILE
VALIDATE $? "enabled the mysqld"

systemctl start mysqld &>>$LOGS_FILE 
VALIDATE $? "started the mysqld"

#get the passward from user
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "setup root user"