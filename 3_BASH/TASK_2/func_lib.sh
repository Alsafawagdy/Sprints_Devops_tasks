#!/usr/bin/env bash

have_Root_Privilage()
{
	user=$(groups $USER)
	if grep -q 'wheel' <<< "$user" || [ $EUID -eq 0 ] ||grep "$USER" "/etc/sudoers";
	then
		echo "You have root privilages"
	else
		echo "you has not the root privilages"

	fi
}

Changing_Port()
{
	echo " you must be a root "
	echo "What would like to change the port to ?"
	read NewPort
	if [[ $NewPort -ge 1024 && $NewPort -le 65535 || $NewPort == 22 ]];
	then	
		if [[ $EUID == 0 ]];then
			# To change any no of port
			sed -i -e "s/^#Port [0-9]*/Port $NewPort/g" /etc/ssh/sshd_config
			sed -i -e "s/^Port [0-9]*/Port $NewPort/g" /etc/ssh/sshd_config
			echo "Restarting SSH in 5 seconds.please wait.."
			sleep 5
			systemctl reload sshd
			echo " The SSh port has been changed to $NewPort"
		else
			sudo  sed -i -e "s/^#Port [0-9]*/Port $NewPort/g" /etc/ssh/sshd_config
                        sudo sed -i -e "s/^Port [0-9]*/Port $NewPort/g" /etc/ssh/sshd_config
                        echo "Restarting SSH in 5 seconds.please wait.."
                        sleep 5
                        sudo systemctl reload sshd
                        echo " The SSh port has been changed to $NewPort"
		fi
	else
		echo "Invalid port, It must be 22 or between 1024 &65535"
	fi
}

Dis_Root_Login()
{
	if [[ $EUID == 0 ]];then
		sed -i -e "s/^#PermitRootLogin [Y,y]es/PermitRootLogin no/g" /etc/ssh/sshd_config
		sed -i -e "s/^PermitRootLogin [Y,y]es/PermitRootLogin no/g" /etc/ssh/sshd_config
		systemctl reload sshd
		echo "Root login disabled sussesfully"
	else
		sudo  sed -i -e "s/^#PermitRootLogin [Y,y]es/PermitRootLogin no/g" /etc/ssh/sshd_config
                sudo sed -i -e "s/^PermitRootLogin [Y,y]es/PermitRootLogin no/g" /etc/ssh/sshd_config
                sudo systemctl reload sshd
                echo "Root login disabled sussesfully"
	fi
}

Add_User()
{
	echo "Please Enter the user name "
	read name
	echo "please enter the password"
	read password
	is_exist=$(grep "^$name" /etc/passwd)
	if  grep -q "$name" <<< "$is_exist";
	then 
		echo "$name is already exist"
	else
		echo "do you want to add this user to the sudoers?(y/n)"
		read answer
		pass=$(perl -e 'print crypt($ARGV[0],"password")' $password)
      		if [[ $answer == [Y,y] ]]
		then
			 if [[ $EUID == 0 ]];then
				useradd -m -p "$pass"  "$name"	
	                	[ $? -eq 0 ] && echo "User has been added" || echo "Failed to add"
				echo "$name	ALL=(ALL)	ALL">>/etc/sudoers
			else
				sudo useradd -m -p "$pass"  "$name"
                                [ $? -eq 0 ] && echo "User has been added" || echo "Failed to add"
                                echo "$name     ALL=(ALL)       ALL" | sudo EDITOR='tee -a' visudo -f /etc/sudoers
			fi
		else
			if [[ $EUID == 0 ]];then
			 	useradd -m -p "$pass"  "$name"
                		[ $? -eq 0 ] && echo "User has been added" || echo "Failed to add"
			else
				sudo useradd -m -p "$pass"  "$name"
                                [ $? -eq 0 ] && echo "User has been added" || echo "Failed to add"
			fi
		fi
	fi
}
backupcron()
{
	if [[ $EUID == 0 ]];then 
		echo "0 12 * * *  tar -cf T2homebackup.tar $HOME " >> "/var/spool/cron/${USER}"
	else
		(crontab -1 2> /dev/null;echo "0 12 * * * tar -cf 2homebackup.tar $HOME ") | crontab -
	fi 
	echo "the backup is added to cron"
}
