#!/bin/bash
export PGPASSWORD="PgAdmin2019"

mkdir /root/backup/`date +'%d_%m_%Y'`

cd /root/backup/`date +'%d_%m_%Y'`

pg_dump -U adminpg -h 127.0.0.1 -p 5432 gitlab > gitlab.dump

cd /root/docker
sudo cp -R gitlab /root/backup/`date +'%d_%m_%Y'`
cd /root/backup
tar cvfz `date +'%d_%m_%Y'`.tar.gz `date +'%d_%m_%Y'`
rm -rf `date +'%d_%m_%Y'`