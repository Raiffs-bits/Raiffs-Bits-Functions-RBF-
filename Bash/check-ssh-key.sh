#!/bin/bash

export LOG="/var/log/RB-Check-ssh-key"

printf "$(date "+%F %R %Z") - Checking if SSH Key for root is present\n" |tee -a ${LOG}

if  grep 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJpmb4ms4t3+/CIg/5PKcjsGMvloUFBxmNHWa6Fr07z larry@raiffsbits.com' /root/.ssh/authorized_keys 2>&1>/dev/null 
then
	printf "$(date "+%F %R %Z") - SSH Key is present\n" |tee -a ${LOG}
else
	printf "$(date "+%F %R %Z") - SSH Key is NOT present. Adding key.\n" |tee -a ${LOG}
	echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJpmb4ms4t3+/CIg/5PKcjsGMvloUFBxmNHWa6Fr07z larry@raiffsbits.com' >> /root/.ssh/authorized_keys
	if [ $? -eq 0 ]
	then
		printf "$(date "+%F %R %Z") - SSH Key added successfully.\n" |tee -a ${LOG}
	else
		printf "$(date "+%F %R %Z") - SSH Key was not added. Please investigate.\n" |tee -a ${LOG}
	fi
fi

printf "$(date "+%F %R %Z") - root SSH Key check Completed.\n"|tee -a ${LOG}
exit $?

