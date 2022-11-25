#!/usr/bin/env bash

source ./func_lib.sh

have_Root_Privilage
Changing_Port  
Dis_Root_Login
Add_User
backupcron

while [[ ! -f $HOME/fileloop.txt ]];
do 
	echo "waiting for fileloop.txt exist"
done	

echo "fileloop is exist"
