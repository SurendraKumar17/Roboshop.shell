#We using this file as a common source file for all the files to get data from here
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