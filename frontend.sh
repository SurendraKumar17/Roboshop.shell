script_location=$(pwd)

yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#As we dont have VI editor to edit the files, we create the file locally and copy the location to where our scripts are exist.

cp $script_location/files/Nginx.Roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx