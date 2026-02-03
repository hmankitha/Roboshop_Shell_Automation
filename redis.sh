USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disabled default redis module"

dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enabled redis:7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "remote port setting done"

sed -i 's/yes/no' /etc/redis/redis.conf
VALIDATE $? "redis configuration done"

systemctl enable redis 
VALIDATE $? "enabled the redis"

systemctl start redis 
VALIDATE $? "started the redis"

