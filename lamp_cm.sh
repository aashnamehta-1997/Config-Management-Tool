#!/usr/bin/env bash
# Config-Management-Tool will check for package updates and existing files before proceeding to setup
# and configure LAMP stack to run a simple PHP web app.

# Checks for package updates
sudo apt-get update

# Checks if the uninstall.txt exists or not
if [ -s deb-packages/uninstall.txt ]; then
# Declares an array rm_list
  declare -a rm_list
  
# Internal File Separator seperates the packages linewise and stores them in var value 
  while IFS='\n' read -r value; do
  
# The value (package name to be uninstalled) is added to the removal list
    rm_list+=( "${value}" )
    
# Fetching the contents from file uninstall.txt
  done < "deb-packages/uninstall.txt"


# To remove the packages from the removal list 
  for rm_pkg in "${rm_list[@]}"
  do
    if dpkg -l | grep -i "${rm_pkg}"; then
    
      # To remove a particular package 
      sudo apt-get remove "${rm_pkg}" 
      
      # Removes all the files or packages that were downloaded as a dependency to this package
      sudo apt-get autoremove 
      
      # To remove any residual package
      sudo apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}') 
      
      # To remove the retrieved packages from the local cache
      sudo apt-get clean 
    fi
  done
fi

# Checks if the install.txt exists or not
if [ -s deb-packages/install.txt ]; then
  
  # Declares an array install_list
  declare -a install_list
  
  # Internal File Separator seperates the packages linewise and stores them in var value 
  while IFS='\n' read -r value; do
      
    # The value (package name to be installed) is added to the removal list  
    install_list+=( "${value}" )
  
  # Fetching the contents from uninstall.txt
  done < "deb-packages/install.txt"

  # Installation of packages from the install.txt
  for in_pkg in "${install_list[@]}"
  do
    # Checking if the packages to be installed are present in the package manager
    if ! dpkg -l | grep "${in_pkg}"; then
    
      # Installing the package mentioned in the install_list
      sudo apt-get install -y "${in_pkg}"
      
      # Installing mysql-server dependencies
      if [ "${in_pkg}" == "mysql-server" ]; then
       
        sudo mysql_install_db

        sudo mysql_secure_installation
      fi
    fi
  done
fi

# Check if the file index.html exists 
if [ -f "/var/www/html/index.html" ]; then
  # Removing index.html
  sudo rm /var/www/html/index.html
  # Creating index.php on the same location as that of index.html
  touch /var/www/html/index.php
fi

# To check if the metadata file containing the package permissions exists or not
if [ -s metadata-userdata/metadata.txt ]; then

# To declare an Associative Array for fetching the metadata
  declare -A metadata
  
  # Internal File Separator used to get key and value and store it in an associative array
  while IFS== read -r key value; do
    metadata[$key]=$value
  done < "metadata-userdata/metadata.txt"
  # To modify the permission and set it to 644 
  sudo chmod "${metadata[permissions]}" "${metadata[file]}"
  # To modify the owner name 
  sudo chown "${metadata[owner]}" "${metadata[file]}"
  # To modify the group name
  sudo chgrp "${metadata[group]}" "${metadata[file]}"
fi

# To declare an Associative Array for fetching the userdata
if [ -s metadata-userdata/userdata.txt ]; then 

  # To declare an Associative Array for fetching the userdata
  declare -A userdata
  
  # Internal File Separator used to get key and value and store it in an associative array
  while IFS== read -r key value; do
    userdata[$key]=$value
    
  # Fetching the contents from file uninstall.txt
  done < "metadata-userdata/userdata.txt"
  
  # Storing the php file content in index.php
  sudo echo "${userdata[content]}" > "${userdata[file]}"
fi

# Checks which services need to be restarted after package upgrades.
needrestart
