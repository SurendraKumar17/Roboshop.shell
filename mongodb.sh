source common.sh

print_head "Copy mongoDB Repo file"
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Update mongoDB listen address" #Substitute the value in the file using SED editor
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "Enable MongoDB"
systemctl enable mongod &>>${LOG}
status_check

print_head "Restart mongod"
systemctl restart mongod &>>${LOG}
status_check