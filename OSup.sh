#!/bin/bash

Update Linux system based on OS selection

Prompt user to select OS

echo "Please select your Linux OS:"
echo "1. Ubuntu"
echo "2. CentOS 9"
echo "3. Suse"
echo "4. Fedora"
echo "5. Manjaro"
read -p "Enter number of your OS: " os_num

Update based on OS selection

case $os_num in
1)
# Update Ubuntu
echo "Updating Ubuntu system..."
apt update && apt upgrade -y
;;
2)
# Update CentOS 9
echo "Updating CentOS 9 system..."
yum update -y
;;
3)
# Update Suse
echo "Updating Suse system..."
zypper refresh && zypper update -y
;;
4)
# Update Fedora
echo "Updating Fedora system..."
dnf update -y
;;
5)
# Update Manjaro
echo "Updating Manjaro system..."
pacman -Syu
;;
*)
# Invalid selection
echo "Invalid selection. Exiting script."
exit 1
;;
esac

echo "Done updating Linux system."
