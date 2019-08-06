#!/bin/bash
failfunction()
{
    if [ "$1" != 0 ]
    then echo "One of the commands has failed!!"
         echo "Subject: Task backup on gitlab failed" | sendmail -v kushlychok@gmail.com
       exit
    fi
}

export PGPASSWORD=`aws ssm get-parameters --name DBpassPG --region us-west-2 --with-decryption --output text --query Parameters[].Value`
mkdir /root/backup/`date +'%d_%m_%Y'`

cd /root/backup/`date +'%d_%m_%Y'`

pg_dump -U adminpg -h 127.0.0.1 -p 5432 gitlab > gitlab.dump
failfunction "$?"
cd /data
sudo cp -R gitlab /root/backup/`date +'%d_%m_%Y'`
cd /root/backup
tar cvfz `date +'%d_%m_%Y'`.tar.gz `date +'%d_%m_%Y'`
failfunction "$?"
rm -rf `date +'%d_%m_%Y'`
aws s3 mv `date +'%d_%m_%Y'`.tar.gz s3://backupgitlab-opsworks/
failfunction "$?"
