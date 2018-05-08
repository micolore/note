#!/bin/bash
function BACKUP(){
    read  -p "Do you want to backup the tablename:"  table
   #备份数据库
   mysqldump -uroot -p!QAZ2wsx  webkit $table > /data/mysqlback/$DATE/"$table"_"$DATE".sql
}
DATE=`date +%Y%m%d`
if [ -f /$DATE ];then
    echo "continue"
    BACKUP
else
   echo "not"
   mkdir /data/mysqlback/$DATE
   BACKUP
fi

