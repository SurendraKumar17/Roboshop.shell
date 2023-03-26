script_location=$(pwd)
##
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org -y

#Substitute the value in the file using SED editor
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

systemctl enable mongod
systemctl restart mongod