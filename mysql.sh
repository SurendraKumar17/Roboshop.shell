source common.sh #

if [ -z "$root_mysql_password" ]; then
  echo "variable root_mysql_password is missing"
  exit
fi

print_head "Disable default mysql module"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Copy mysql Repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install mySQL server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable mySQL"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Restart mysql"
systemctl restart mysqld &>>${LOG}
status_check

print_head "Reset default database password"
mysql_secure_installation --set-root-pass $root_mysql_password &>>${LOG}
status_check