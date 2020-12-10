# Config-Management-Tool (OPS ASSIGNMENT 2)

This tool is a rudimentary configuration management tool to configure servers for the production service of a simple PHP web application. It is a tool similar to Puppet or Chef.

## Requirements for the rudimentary configuration management tool:

#### * If your tool has dependencies not available on a standard Ubuntu instance you may include a bootstrap.sh program to resolve them

bootstrap.sh file has been created to install needrestart which provides a mechanism for restarting a service when relevant files or packages are updated

#### * Your tool must provide an abstraction that allows specifying a file's content and metadata (owner, group, mode)

metadata.txt provides an abstraction that allows specifying metadata (owner, group, mode) and userdata.txt stores the file's content.The key value pairs are extracted from metadata.txt and userdata.txt by Internal File Separator. Key value pairs must be separated by "=" and each on it's own line. Again, trailing whitespace should be avoided.

#### * Your tool must provide an abstraction that allows installing and removing Debian packages

deb-packages includes install.txt and uninstall.txt. It is an abstraction that allows installing and removing Debian packages.

#### * Your tool must provide some mechanism for restarting a service when relevant files or packages are updated

needrestart is used as a mechanism for restarting a service when relevant files or packages are updated

#### * Your tool must be idempotent - it must be safe to apply your configuration over and over again

The tool is idempontent and safe to apply. 

## Note:
1. Please make sure that the versions of different packages are available and are compatible with each other eg. versions of PHP less than 5 are not available by default in Linux and package version compatibility should also be checked.

2. Only one version number of a package should be installed to avoid discrepancies. eg. php7.2 and libapache2-mod-php7.2 should be installed.                    php7.2 and libapache2-mod-php7.1 should not be installed. 

3. We should avoid deleting from the terminal directly and should use the Config-Management-Tool to remove all residual or dependent packages as well.

4. The Machines may require a reboot due to the needrestart functionality which prompts for a service restart whenever packages are updated.Linux doesnot allow/recommend restarting the dbus (dbus.service) and systemd (systemd-journald.service, systemd-logind.service) manually so it might prompt for a system restart.The other services are restarted automatically by the Config-Mangement-Tool.

## Architecture of the Tool:

``` bash
  config_management_tool/
  +-- deb-packages
      +-- install.txt
      +-- uninstall.txt
  +-- dependencies
      +-- bootstrap.sh
  +-- metadata-userdata
      +-- metadata.txt
      +-- userdata.txt
  +-- lamp_cm.sh

```
      
## Configuration:

### Installation of a Package:
To install a package, add the package name to the text file labeled "install.txt", inside the "deb-packages" directory. Each package name should be on it's own line without any trailing whitespace.

### Removal of a Package:
To remove an installed package, add the package name to the text file labeled "uninstall.txt", inside the "deb-packages" directory. Each package name should be on it's own line without any trailing whitespace.

### Setting the Metadata:
To set metadata and file content, you will need to add key value pairs into the "metadata.txt" file and "userdata.txt". Key value pairs must be separated by "=" and each on it's own line. Again, trailing whitespace should be avoided. Inside the metadata file, you will find examples from which you can edit.

## Installation and Invokation Procedure:

### Transfer directory to the destination server using the following syntax:
scp -r config-management-tool/ your_username@remotehost
### CD into the directory
cd config-management-tool/
### Make the scripts executable
chmod +x lamp_cm.sh dependencies/bootstrap.sh
### Install dependency
dependencies/bootstrap.sh
### Run the script
./lamp_cm.sh
 
