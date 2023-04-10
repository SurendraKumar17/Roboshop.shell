source common.sh

if [ -z "$roboshop_rabbitmq_password"]; then
  echo "variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "Configuring Erlang YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install Erlang"
yum install erlang -y &>>${LOG}
status_check

print_head "Configuring RabbitMQ YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Add application user"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop $roboshop_rabbitmq_password &>>${LOG}
fi
status_check

print_head "Add tags to application user"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head "add permissions to application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check

#Execution : export roboshop_rabbitmq_password=roboshop123

#Sudo -E bash rabbitmq.sh