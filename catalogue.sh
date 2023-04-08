source common.sh

print_head "Configuring NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add application user"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app &>>${LOG}

print_head "Downloading app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "Clean Up old content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting app content"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Installing NodeJS Dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "Configuing catalogue service File"
cp $script_location/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Reload systemD"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable catalogue service"
systemctl enable catalogue &>>${LOG}
status_check

print_head "Start catalogue service"
systemctl start catalogue &>>${LOG}
status_check

print_head "Configuring Mongo Repo"
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install MongoDB Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.surendrak.online </app/schema/catalogue.js &>>${LOG}
status_check