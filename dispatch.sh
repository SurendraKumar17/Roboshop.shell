source common.sh

print_head "Install golang"
yum install golang -y &>>${LOG}
status_check

print_head "App application user"
useradd  roboshop &>>${LOG}
status_check

print_head "download dispatch details"
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>${LOG}
cd /app
unzip /tmp/dispatch.zip &>>${LOG}
status_check

print_head " "
cd /app
go mod init dispatch &>>${LOG}
go get &>>${LOG}
go build &>>${LOG}
status_check

print_head " "
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable dispatch"
systemctl enable dispatch &>>${LOG}
status_check

print_head "start dispatch"
systemctl start dispatch &>>${LOG}
status_check