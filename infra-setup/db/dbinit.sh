#!/bin/sh
MY_USER_MASTER="master"
MY_PASS_MASTER="abcdefghijklmnopqrstuvwxyz1234567890"
MY_DBNAME_APP1=tyropower
MY_USER_APP1=tyropower
MY_PASS_APP1=0987654321zyxwvutsrqponmlkjihgfedcba
MY_HOST1=`aws ssm get-parameter --with-decryption --name "/tyropower/${ENV}/mysql/host/reader" --query 'Parameter.Value'|sed -e 's/^"//' -e 's/"$//'|cut -d ':' -f1`
MY_HOST=`echo $MY_HOST1| cut -d ':' -f1`
# Install MySQL client
apk add mysql mysql-client

# BehavioSense User
mysql --user=${MY_USER_MASTER} --password=${MY_PASS_MASTER} --host=${MY_HOST} --database=${MY_DBNAME_APP1} --execute="CREATE USER ${MY_USER_APP1}@'%' IDENTIFIED BY '${MY_PASS_APP1}';"
mysql --user=${MY_USER_MASTER} --password=${MY_PASS_MASTER} --host=${MY_HOST} --database=${MY_DBNAME_APP1} --execute="GRANT ALL PRIVILEGES ON ${MY_DBNAME_APP1}.* TO ${MY_USER_APP1}@'%';"
mysql --user=${MY_USER_MASTER} --password=${MY_PASS_MASTER} --host=${MY_HOST} --database=${MY_DBNAME_APP1} --execute="FLUSH PRIVILEGES;"

# BehavioSense schema
mysql --user=${MY_USER_MASTER} --password=${MY_PASS_MASTER} --host=${MY_HOST} --database=${MY_DBNAME_APP1} < tyropower.sql
