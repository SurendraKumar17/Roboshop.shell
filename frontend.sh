source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "Remove Nginx old content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

print_head "Extract frontend content"
unzip /tmp/frontend.zip &>>${LOG}
status_check

##As we dont have VI editor to edit the files, we create the file locally and copy the location to where our scripts are exist.
print_head "Copy roboshop nginx conf file"
cp $script_location/files/nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "Enable Nginx "
systemctl enable nginx &>>${LOG}
status_check

print_head "Start Nginx"
systemctl start nginx &>>${LOG}
status_check

print_head " Restart nginx"
systemctl restart nginx &>>${LOG}
status_check