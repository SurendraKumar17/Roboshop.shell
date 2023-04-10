#We using this file as a common source file for all the files to get data globally..
script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() { #funtion
  if  [ $? -eq 0 ]; then
      echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer log file for more info , LOG - ${LOG}"
    exit
    fi

}


print_head () {
  echo -e "\e[1m $1 \e[0m"

}

APP_PREREQ() {

  print_head "Add application user"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>${LOG}
  fi
  status_check

  mkdir -p /app &>>${LOG}

  print_head "Downloading app content"
  curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${LOG}
  status_check

  print_head "Clean Up old content"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Extracting app content"
  cd /app
  unzip /tmp/$component.zip &>>${LOG}
  status_check
}

SYSTEMD_SETUP () {

    print_head "Configuing $component service File"
    cp $script_location/files/$component.service /etc/systemd/system/$component.service &>>${LOG}
    status_check

    print_head "Reload systemD"
    systemctl daemon-reload &>>${LOG}
    status_check

    print_head "Enable $component service"
    systemctl enable $component &>>${LOG}
    status_check

    print_head "Start $component service"
    systemctl start $component &>>${LOG}
    status_check
}

LOAD_SCHEMA () {

  if [ $schema_load == "true" ]; then
     if [ $schema_type == "mongo" ]; then
       print_head "Configuring Mongo Repo"
       cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
       status_check

       print_head "Install MongoDB Client"
       yum install mongodb-org-shell -y &>>${LOG}
       status_check

       print_head "Load Schema"
       mongo --host mongodb-dev.surendrak.online </app/schema/$component.js &>>${LOG}
       status_check
     fi

     if [ $schema_type == "mysql" ]; then
       print_head "Install mysql Client"
       yum install mysql -y &>>${LOG}
       status_check

       print_head "Load Schema"
       mysql -h mysql-dev.surendrak.online -uroot -p$root_mysql_password < /app/schema/shipping.sql  &>>${LOG}
       status_check
     fi
  fi
}

NODEJS() {
  print_head "Configuring NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install NodeJS"
  yum install nodejs -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Installing NodeJS Dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  SYSTEMD_SETUP
  LOAD_SCHEMA
}


MAVEN () {

  print_head "Install Maven"
  yum install maven -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Build a package"
  mvn clean package &>>${LOG}
  status_check

  print_head "Copy a file to app location"
  mv target/$component-1.0.jar $component.jar
  status_check

  SYSTEMD_SETUP
  LOAD_SCHEMA

}

PYTHON () {

    print_head "Install python"
    yum install python36 gcc python3-devel -y &>>${LOG}
    status_check

    APP_PREREQ

    print_head "download dependencies"
    cd /app
    pip3.6 install -r requirements.txt &>>${LOG}
    status_check

    print_head "update passwords in service file"
    sed -i -e "s/roboshop_rabbitmq_password/$roboshop_rabbitmq_password/" $script_location/files/$component.service &>>${LOG}
    status_check

    SYSTEMD_SETUP
    LOAD_SCHEMA

}


GOLANG() {

  print_head "Install golang"
  yum install golang -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head " Download dependencies "
  cd /app
  go mod init dispatch &>>${LOG}
  go get &>>${LOG}
  go build &>>${LOG}
  status_check

  print_head "update passwords in service file"
  sed -i -e "s/roboshop_rabbitmq_password/$roboshop_rabbitmq_password/" $script_location/files/$component.service &>>${LOG}
  status_check

  SYSTEMD_SETUP

}