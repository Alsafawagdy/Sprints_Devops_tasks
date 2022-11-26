#!/usr/bin/env bash

source ./func_lib.sh

while true 
do 
	echo "please choose number from the following:"
	echo "1 -> check root privilage"
	echo "2 -> changing port"
	echo "3 -> disable root login"
	echo "4 -> Add user"
	echo "5 -> backup home directory"
	read ans
	case $ans in 
		1)have_Root_Privilage;;
		2)Changing_Port;;
		3)Dis_Root_Login;;
		4)Add_User;;
		5)backupcron;;
	esac
	echo "Do you want to do sth else?[y/n]"
	read ans2
	if [[ "$ans2" == "n" || "$ans2" == "N" ]];then
		break
	fi
done 

while [[ ! -f $HOME/fileloop.txt ]];
do 
	echo "waiting for fileloop.txt exist"
done	

echo "fileloop is exist"



