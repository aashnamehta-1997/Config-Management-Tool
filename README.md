# Config-Management-Tool (OPS ASSIGNMENT 2)

This tool is a rudimentary configuration management tool to configure servers for the production service of a simple PHP web application. It is a tool similar to Puppet or Chef.

## Requirements for the rudimentary configuration management tool:

### If your tool has dependencies not available on a standard Ubuntu instance you may include a bootstrap.sh program to resolve them

 bootstrap.sh file has been created to install needrestart which provides a mechanism for restarting a service when relevant files or packages are updated

### Your tool must provide an abstraction that allows specifying a file's content and metadata (owner, group, mode)

 metadata.txt provides an abstraction that allows specifying a file's content and metadata (owner, group, mode).To set metadata and file content, you will need to add key value pairs into the "metadata.txt" file. Key value pairs must be separated by "=" and each on it's own line. Again, trailing whitespace should be avoided. Inside the metadata file, you will find examples from which you can edit.

### Your tool must provide an abstraction that allows installing and removing Debian packages

debian_packages includes install.txt and uninstall.txt. It is an abstraction that allows installing and removing Debian packages.
 

### Your tool must provide some mechanism for restarting a service when relevant files or packages are updated

 needrestart is used as a mechanism for restarting a service when relevant files or packages are updated

### Your tool must be idempotent - it must be safe to apply your configuration over and over again

The tool is idempontent and safe to apply

The tool may require a reboot once the script has ran because of the needrestart command. The needrestart command checks if a restart is required after relevant files or packages are updated. 

Linux doesnot allow/recommend restarting the following services manually:

dbus (dbus.service)
systemd (systemd-journald.service, systemd-logind.service)

so It might prompt a system restart is required


Failed to check for processor microcode upgrades.

## Architecture of the Tool:

``` bash
  Server_Config/
  +-- bootstrap.sh
  +-- lamp_cm.sh
  +-- metadata.txt
  +-- debian_packages
      +-- install.txt
      +-- uninstall.txt
```
      
## Configuration:

### Installation of a Pakage:
To install a package, add the package name to the text file labeled "install.txt" inside the "debian_packages" directory. Each package name should be on it's own line without any trailing whitespace.

### Removal of a Package:
For removing an installed package, follow you will do the same as you did to install a package. This time you will add the package names to the "uninstall.txt" file inside the "debian_packages" directory.

### Setting the Metadata:
To set metadata and file content, you will need to add key value pairs into the "metadata.txt" file. Key value pairs must be separated by "=" and each on it's own line. Again, trailing whitespace should be avoided. Inside the metadata file, you will find examples from which you can edit.

## Installation and Invokation Procedure:

### Transfer directory to the destination server using the following syntax:
scp -r config-management-tool/ your_username@remotehost

### CD into the directory
cd config-management-tool/

### Make the scripts executable
chmod +x lamp_cm.sh bootstrap.sh

### Install dependency
./bootstrap.sh

### Run the script
./lamp_cm.sh
 
