#!/usr/bin/env bash


sudo apt-get update

if [ -s deb-packages/uninstall.txt ]; then
  echo "inside if rm"
  declare -a rm_list
  while IFS='\n' read -r value; do
    rm_list+=( "${value}" )
  done < "deb-packages/uninstall.txt"

 
  for rm_pkg in "${rm_list[@]}"
  do
    if dpkg -l | grep -i "${rm_pkg}"; then
      sudo apt-get remove "${rm_pkg}" 
      sudo apt-get autoremove 
      sudo apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}') 
      sudo apt-get clean 
    fi
  done
fi

if [ -s deb-packages/install.txt ]; then
  echo "inside if install"
  declare -a install_list
  while IFS='\n' read -r value; do
    install_list+=( "${value}" )
  done < "deb-packages/install.txt"

 
  for in_pkg in "${install_list[@]}"
  do
    if ! dpkg -l | grep "${in_pkg}"; then
      sudo apt-get install -y "${in_pkg}"
      if [ "${in_pkg}" == "mysql-server" ]; then
       
        sudo mysql_install_db

        
        sudo mysql_secure_installation
      fi
    fi
  done
fi


if [ -f "/var/www/html/index.html" ]; then
  sudo rm /var/www/html/index.html
  touch /var/www/html/index.php
fi


if [ -s metadata-userdata/metadata.txt ]; then
  echo "inside metadata.txt"	
  declare -A metadata
  while IFS== read -r key value; do
    metadata[$key]=$value
  done < "metadata-userdata/metadata.txt"
  sudo chmod "${metadata[permissions]}" "${metadata[file]}"
  sudo chown "${metadata[owner]}" "${metadata[file]}"
  sudo chgrp "${metadata[group]}" "${metadata[file]}"
fi
if [ -s metadata-userdata/userdata.txt ]; then
  echo "inside userdata.txt"    
  declare -A userdata
  while IFS== read -r key value; do
    userdata[$key]=$value
  done < "metadata-userdata/userdata.txt"
  sudo echo "${userdata[content]}" > "${userdata[file]}"
fi

needrestart
