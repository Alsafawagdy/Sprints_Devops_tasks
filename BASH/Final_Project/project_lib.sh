#!/usr/bin/env bash

Func_Menu()
{	
	while true 
	do
		echo "please choose number from the following"
		echo " 1 -> Change port"
		echo " 2 -> Disable root login"
		echo " 3 -> update firewall and selinux"
		echo " 4 -> Add Audit group"
		echo " 5 -> Add user with password"
		echo " 6 -> create reports for the whole 2021 and edit permissions"
		echo " 7 -> update and upgrade your system"
		echo " 8 -> enable EPEL repository"
		echo " 9 -> install fail2ban @ boot"
		echo " 10 -> add report backup to cron"
		echo " 11 -> add manger user"
		echo " 12 -> sync the reports"
		echo " q -> Exit"
		read number
		if [[ $number == q ]];then
			break
		elif [[ $number -ge 0 &&  $number -le 13 ]];then 
			case $number in
				1)changing_ssh_port "$1";;
				2)Dis_Root_Login;;
				3)update_firewall_selinux "$1";;
				4)add_group;;
				5)add_user "$2" "$3";;
				6)create_reports;;
				7)update_system;;
				8)enable_epel;;
				9)fail2ban;;
				10)report_cron;;
				11)add_manager;;
				12)sync;;
			esac
		else
		      echo "Invalid number,please choose from 1 to 15"	
		fi
		echo "do you want to continue?(y/n)"
		read ans
		if [[ "$ans" == "n" ]] || [[ "$ans" == "N" ]];then 
			break
		fi
	done
}

root_privilages()
{
	user=$(groups $USER)
        if grep -q 'wheel' <<< "$user" || [ $EUID -eq 0 ] ||grep "$USER" "/etc/sudoers";
        then
                echo "$USER has root privilages"
		return 1
        else
                echo "$USER  has not the root privilages"
		return 0

        fi

}


changing_ssh_port()
{
	echo "port number you choose is $1"
	if [[ $1 -ge 1024 && $1 -le 65535 || $1 == 22 ]];
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

update_firewall_selinux()
{
	if [[ $EUID == 0 ]];then
		semanage port -a -t ssh_port_t -p tcp $1
		echo "selinux is updated to port $1 successfully"
		firewall-cmd --add-port=$1/tcp --permanent
		firewall-cmd --reload
		systemctl reload firewalld.service
		echo "firewall is updated to port $1 successfully"
	else
		sudo semanage port -a -t ssh_port_t -p tcp $1
                echo "selinux is updated to port $1 successfully"
	        sudo firewall-cmd --add-port=$1/tcp --permanent
                sudo firewall-cmd --reload
                echo "firewall is updated to port $1 successfully"
	fi
}

add_group()
{
	if [[ $EUID == 0 ]];then
		groupadd -f Audit -g 20000 
		echo "Audit group is added successfully"
	else
		sudo groupadd -f Audit -g 20000
                echo "Audit group is added successfully"
	fi
}

add_user()
{
	pass=$(perl -e 'print crypt($ARGV[0],"password")' $2)
	is_exist=$(grep "^$1" /etc/passwd)
        if  grep -q "$1" <<< "$is_exist";
        then
                echo "$1 is already exist"
        else
		if [[ $EUID == 0 ]];then
			useradd -m -p "$pass"  "$1" -g Audit
			[ $? -eq 0 ] && echo "User has been added" || echo "Failed to add user"
		else
			sudo useradd -m -p "$pass"  "$1" -g Audit
                        [ $? -eq 0 ] && echo "User has been added" || echo "Failed to add user"
		fi
	fi
}

update_system()
{	if [[ $EUID == 0 ]];then
		yum update -y
		echo "The system has been updated successfully"
	else
		sudo yum update -y
		echo "The system has been updated successfully"
	fi
}
enable_epel()
{
	if [[ $EUID == 0 ]];then
		yum install epel-release -y
       		echo "EPEL repository is enabled successfully"	
	else
		sudo yum install epel-release -y
                echo "EPEL repository is enabled successfully" 
	fi
}

fail2ban()
{
	if [[ $EUID == 0 ]];then
		yum install fail2ban
		systemctl enable fail2ban
		systemctl start fail2ban
		echo " fail2ban is installed and enabled successfully"
	else
		sudo yum install fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl start fail2ban
                echo " fail2ban is installed and enabled successfully"
	fi
}

add_manager()
{	
	if [[ $EUID == 0 ]];then
		useradd -u 30000 manager
	else
		sudo useradd -u 30000 manager
	fi
}
create_reports()
{
	if [[ $EUID == 0 ]];then
		mkdir -p ~/reports/
		for i in 1 3 5 7 8 10 12
	        do
        	        touch ~/reports/2021-$i-{01..31}.xls
       		done
	        for i in 4 6 9 11
       		do
               	        touch ~/reports/2021-$i-{1..30}.xls
      		done
        		touch ~/reports/2021-2-{1..28}.xls
		echo " Reports files are created successfully"
		chmod -R 660  $HOME/reports
		echo " updating files permissions"
		echo " only user and group can read and write"
	else
		sudo mkdir -p ~/reports/
                for i in 1 3 5 7 8 10 12
                do
                        sudo touch ~/reports/2021-$i-{01..31}.xls
                done
                for i in 4 6 9 11
                do
                        sudo touch ~/reports/2021-$i-{1..30}.xls
                done
                        sudo touch ~/reports/2021-2-{1..28}.xls
                echo " Reports files are created successfully"
                sudo chmod -R 660  $HOME/reports
                echo " updating files permissions"
                echo " only user and group can read and write"
	fi
}

report_cron()
{
	if  [[ $EUID == 0 ]];then
		echo "0 1 * * 1-4 tar -cf /root/backups/reports-$(date +%U)-$(date +%u).tar  ~/reports" >> /var/spool/cron/root
	else
		(crontab -1 2>/dev/null;echo "0 1 * * 1-4 tar -cf /root/backups/reports-$(date +%U)-$(date +%u).tar  ~/reports")| crontab -
	fi
	echo "backup schedule is updates successfully"
}
sync()
{
	mkdir -p  ~/manager/audit/reports
	if  [[ $EUID == 0 ]];then
		echo "0 2 * * 1-4 sync ~/reports/* ~/manager/audit/reports" >> /var/spool/cron/root

	else
		(crontab -1 2>/dev/null;echo "0 2 * * 1-4 sync ~/reports/* ~/manager/audit/reports")|crontab -
	fi
	echo "sync is done successfully"
}
#Func_Menu $1 $2 $3
