source common.sh
print_head "Set up Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print_head "Enable Redis 6.2 dnf module"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head "Install Redis"
yum install redis -y &>>${LOG}
status_check

print_head "update Redis listen adress"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
status_check

print_head "Enable Redis"
systemctl enable redis &>>${LOG}
status_check

print_head "Start Redis"
systemctl start redis &>>${LOG}
status_check