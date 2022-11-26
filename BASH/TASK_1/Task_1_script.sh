#!/usr/bin/bash

currenttime=$(date +%H:%M)

echo "checking directories and files "

if [[ ! -d ~/Reports ]];
then
	mkdir -p ~/Reports/2022/
	for i in 1 3 5 7 8 10 12
        do      
		mkdir ~/Reports/2022/$i/
		touch ~/Reports/2022/$i/{01..31}.xls
	done 
	for i in 4 6 9 11
        do
                mkdir ~/Reports/2022/$i/
                touch ~/Reports/2022/$i/{1..30}.xls
        done
        mkdir ~/Reports/2022/2
	touch ~/Reports/2022/2/{1..28}.xls
	echo "Creating directories and files"


elif [[ ! -d ~/Reports/2022  ]];
then
	mkdir -p ~/Reports/2022/
        for i in 1 3 5 7 8 10 12
        do
                mkdir ~/Reports/2022/$i/
                touch ~/Reports/2022/$i/{01..31}.xls
        done
        for i in 4 6 9 11
        do
                mkdir ~/Reports/2022/$i/
                touch ~/Reports/2022/$i/{1..30}.xls
        done
        mkdir ~/Reports/2022/2
        touch ~/Reports/2022/2/{1..28}.xls
	echo "creating files"

elif [[ ! -f ~/Reports/2022/$(date +%m)/$(date +%d).xls ]];
then
	touch ~/Reports/2022/$(date +%m)/$(date +%d).xls
	echo "Creating today's Report"
fi

echo "Every thing is ok"

if [[ ! -d ~/backups ]];
then 
	mkdir ~/backups
fi


if [[ "$currenttime" > "00:00" ]] && [[ "$currenttime" < "05:00" ]];
then
	tar -cf $(date +%Y-%m-%d).tar ~/reports/$(date +%Y)/$(date +%m)/$(date +%d).xls
	mv $(date +%Y-%m-%d).tar ~/backups
	echo "backup has done successfully"
else
	echo "sorry. the backup must be between 12AM & 5AM"	
fi
if [[ $EUID == 0 ]];then	
	echo "0 0-5 * * * root tar ~/backups/-cf $(date +%Y-%m-%d).tar ~/reports/$(date +%Y)/$(date +%m)/$(date +%d).xls" >>/var/spool/cron/root
else
	 ( crontab -1 2>/dev/null;echo " 0 0-5 * * * root tar ~/backups/-cf $(date +%Y-%m-%d).tar ~/reports/$(date +%Y)/$(date +%m)/$(date +%d).xls") |crontab -
fi
	
