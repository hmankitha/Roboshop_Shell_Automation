#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31"
G="\e[32"
Y="\e[33"
N="\e[34"

if [ $USERID -nq 0 ]; then 
    echo -e "$R Please run this script with root user access $N | tee -a $LOGS_FILE
    exit 1
fi 

mkdir -p $LOGS_FOlDER

VALIDATE(){
    if [ $1 -nq 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
    else 
        echo -e "$2 ... $G SUCESS $N" | tee -a $LOGS_FILE
    fi    

}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y
VALIDATE $? "Installing Mongodb Server "

systemctl enable mongod
VALIDATE $? "Enable mongod"

systemctl start mongod
VALIDATE $? "started mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongo.conf
VALIDATE $? "Allowing remote connections" 

systemctl restart mongo
VALIDATE $? "Restarted mongodb"