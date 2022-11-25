#!/usr/bin/bash
source project_lib.sh

root_privilages

res=$?
if [[ $res == 1 ]];then
	Func_Menu $1 $2 $3

else 
	echo  "i am sorry you can't run the script"
fi


