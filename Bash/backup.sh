#!/bin/bash
#

########## CORE OPTIONS ##########
LOG="/root/www-backup/Backup-Log"
backupsource+=( "/var/www/html" "/var/www/ssl" "/usr/local/lsws" "/var/lib/mysql" "/var/log" "/etc" "/home" "/root" )
MySQLUSR="root"
MySQLPWFile="/root/.db_password"


##########  Local Backup Options ##########
# Options for Local Backup. Set for This Server
# #############################################

BKUPDIR="/root/SRV_backup/"

# END Local Backup Options
# ########################


########## Remote Backup Options ##########
# Options for remote rsync/sftp/ftp backups
# Set options for remote backups. This server -->> remote server
# ##############################################################

# 		**** Not Yet Implementated ****
################################################################

REMOTE_SRV=""
REMOTE_PROTOCOL=""
REMOTE_USER=""
REMOTE_PASSWD=""
REMOTE_USE_PASSWD="0"
REMOTE_USE_KEY="1"

########## DO NOT CHANGE THESE VARIABLES ##########
###################################################
declare -a backupsource
DIR1="$( echo ${DIR} | sed "s/\//-/g")" # replace / for - in dir names for tar
DATETMTZ="$(date +%A-%F-%T-%Z)"
MySQLPWFile="/root/.db_password"
MySQLPW="$(grep root_mysql ${MySQLPWFile} |cut -d \" -f2)"






######################################## DO NOT EDIT ANYTHING BELOW THIS LINE ########################################
######################################################################################################################

$(which logger) "Starting Local Backup  $(date +%A-%F-%T-%Z)"
if [ ! -f ${BKUPDIR} ]
then
	printf "Local Backup Directory Doesnt Exist - Fixing\t"
	mkdir -p ${BKUPDIR}
	if [ $? -eq 0 ]
	then 
		printf "OK\n" |tee -a ${LOG}
	else
		printf "FAIL\n"|tee -a ${LOG}
	fi
fi


for DIR in ${backupsource[@]} 
do
	$(which tar) -czvf ${BKUPDIR}${DIR}-$(date +%A-%F-%T-%Z).tgz ${DIR} |tee -a ${LOG}
	if [ $? -eq 0 ]
then
        printf "Local Backup of ${DIR} Successful\n" |tee -a ${LOG}
        $(which logger) "Local Backup of ${DIR} Successful $(date +%A-%F-%T-%Z)"
else
        printf "Local Backup of ${DIR} Failed\n\n" |tee -a ${LOG}
        $(which logger) "Local Backup of ${DIR} Failed $(date +%A-%F-%T-%Z)"
fi

done

#  Not needed -- to remove 
#$(which tar) -czvf ${BKUPDIR}www-backup-$(date +%A-%F-%T-%Z).tgz /var/www/html |tee -a ${LOG}
#if [ $? -eq 0 ]
#then
#	printf "Backup of /var/www/html Successful\n" |tee -a ${LOG}
#	$(which logger) "Backup of /var/www/html Successful $(date +%A-%F-%T-%Z)"
#else
#	printf "Backup of /var/www/html Failed\n\n" |tee -a ${LOG}
#	$(which logger) "Backup of /var/www/html Failed $(date +%A-%F-%T-%Z)"
#fi
###############
#

# Dump MySQL DBs
# ##############

# All DBs
mysqldump -p${MySQLPW} --dump-date --all-databases >/root/${BKUPDIR}/BACKUP-ALL-DB-$(date +%A-%F-%T-%Z)

# Joomla DB Specifically 
mysqldump -p${MySQLPW} -Djoomla --dump-date --all-databases >/root/${BKUPDIR}/BACKUP-JOOMLA-DB-$(date +%A-%F-%T-%Z)

printf "\n\n\nBACKUP COMPLETED\n\n\n\n"
logger "BACKUP COMPLETED"
exit $?
