#!/bin/bash
#to run this script you need to know the date for example 05_08_2019 to run it: ./restore.sh 05_08_2019
export PGPASSWORD=`aws ssm get-parameters --name POSTGRES_PAS --region us-west-2 --with-decryption --output text --query Parameters[].Value`
file=$1
echo $1
cd /root/backup
aws s3 cp s3://backupgitlab-opsworks/$file.tar.gz /root/backup
tar xvzf $file.tar.gz

cd /root/backup/$file

cp -r gitlab /data

psql -U adminpg -h 127.0.0.1 -p 5432 -d gitlab < gitlab.dump
