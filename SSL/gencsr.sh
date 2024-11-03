#!/bin/bash
#


## dont run yet ##
printf "\n\n\n\n\nwhy are you running me? \n\nINCOMPLETE - Exiting\n\n"
printf "\n\n\nAttempt to run incomplete script by $(id -un)\n\n\n"|mail -s "script run $(date +%F_%T%Z)" root
exit 255
## end catchall ##
#

OSSL=$(which openssl)

CheckEnv() {

if [ ${UID} -ne "0" ]
then
	printf "\nFATAL ERROR: You must be root to execute this script. Please re-run as root\n\n"
fi


if [ ! -d KEY ]
then
	printf "\nFATAL ERROR: KEY directory doesnt exist. Please correct this and re-run\n\n"
elif
	[ ! -d CSR ]
then
	printf "\nFATAL ERROR: CSR directory doesnt exist. Please correct this and re-run\n\n"
fi

if [ ! -f ${OSSL} ]
then
	printf "\nFATAL ERROR: Can Not Find OpenSSL. Please Fix And Re-run\n\n"
fi
ExecuteMenu
}

ExecuteMenu() {

clear
printf "\n\n\t\t\tGenerate CSR - Version 1.0 - Copyright 2024 Raiffs Bits LLC\n\t\t\tScript May be used, Distributed, or altered in accordance with the terms of GPLv3\n\n\n"

echo << EOF

			Select Function:

			1	Create Single Domain CSR
			2	Create Multi  Domain CSR
			3	List CSRs Already Created
			4	List Content Of A CSR
			5	Backup Data
			6	Exit

EOF

case $OPTION in
	1)
		Create_Single_CSR
		;;
	2)
		Create_Multi_CSR
		;;
	3)
		List_CSRs
		;;
	4)
		List_CSR_Content
		;;
	5)
		Create_Backup_CSR
		;;
	6)
		exit $?
		;;
esac

return $?
}


Create_Single_CSR() {


read -p  "Enter A Name For This CSR: " CSR_NAME


if [ -f KEY/${CSR_NAME} ]
then
	declare -x CONT_CSR="0"
	printf "\nWARNING: A key with this name already exists.\n"
	read -p "Do You Wish To Backup ${CSR_NAME} And Continue?  [Yy]es  [Nn]o*" BACKUP_CONT_CHOICE
	
	until [ ${CONT_CSR} -eq "1" ]
	do
	case BACKUP_CONT_CHOICE in 
		Y|y)
			mv -v KEY/${CSR_NAME}.key KEY/${CSR_NAME}.key-BACKUP_$(date +%F_%T%Z)
			mv -v CSR/${CSR_NAME}.csr CSR/${CSR_NAME}.csr-BACKUP_$(date +%F_%T%Z)
			openssl genrsa -out KEY/${CSR_NAME}.key 4096
			read -p "What CN (Hostname/Domain Name) Is This For? " CSR_CN
			if [ -f KEY/${CSR_CN} ]
			then
				printf "\nERROR: CSR Exists - Try Again....\n"
				Create_Single_CS
			else
				cat DEFAULT-LOCALITY-RB-CERT.conf > CSR/${CSR_NAME}.conf
				sed -i "s/PLACEHOLDERCNENTRY/${CSR_CN}/g" CSR/${CSR_NAME}.conf
				openssl req -new -key KEY/${${CSR_NAME}}.key -out CSR/${${CSR_NAME}}.csr -config CSR/${CSR_NAME}.conf
				printf "\n\nCSR Created:\t$(ls KEY/${CSR_NAME})\tCSR/${CSR_NAME}\n\n"
				sleep 3
				CheckEnv
			fi
				declare -x CONT_CSR="1"
			;;
		N|n)
				declare -x CONT_CSR="1"
				printf "\n CSR Creation Aborted By User\n\n"
                                sleep 3
                                CheckEnv
			;;
		*)
			declare -x CONT_CSR="0"
			printf "\nINVALID OPTION -- TRY AGAIN....\n\n"
			sleep 2
			;;
		esac
	done
fi


if [ -f CSR/${CSR_NAME} ]
then
        declare -x CONT_CSR="0"
        printf "\nWARNING: A CSR with this name already exists.\n"
        read -p "Do You Wish To Backup ${CSR_NAME} And Continue?  [Yy]es  [Nn]o*" BACKUP_CONT_CHOICE_CSR

        until [ ${CONT_CSR} -eq "1" ]
        do
        case BACKUP_CONT_CHOICE_CSR in
                Y|y)
			declare -x CONT_CSR="1"
			mv -v CSR/${CSR_NAME}.csr CSR/${CSR_NAME}.csr-BACKUP_$(date +%F_%T%Z)
			cat DEFAULT-LOCALITY-RB-CERT.conf > CSR/${CSR_NAME}.conf
                                sed -i "s/PLACEHOLDERCNENTRY/${CSR_CN}/g" CSR/${CSR_NAME}.conf
                                openssl req -new -key KEY/${CSR_NAME}.key -out CSR/${CSR_NAME}.csr -config CSR/${CSR_NAME}.conf
                                printf "\n\nCSR Created:\t$(ls KEY/${CSR_NAME})\tCSR/${CSR_NAME}\n\n"
                                sleep 3
                                CheckEnv
			;;
		N|n)
			printf "\n CSR Creation Aborted By User\n\n"
			sleep 3
			unset CONT_CSR
			CheckEnv
			;;
		*)
			printf "\nINVALID OPTION.... TRY AGAIN....\n"
			sleep 3
			;;
		esac
	done
fi




				cat DEFAULT-LOCALITY-RB-CERT.conf > CSR/${CSR_NAME}.conf
                                sed -i "s/PLACEHOLDERCNENTRY/${CSR_CN}/g" CSR/${CSR_NAME}.conf
                                openssl req -new -key KEY/${CSR_NAME}.key -out CSR/${CSR_NAME}.csr -config CSR/${CSR_NAME}.conf
                                printf "\n\nCSR Created:\t$(ls KEY/${CSR_NAME})\tCSR/${CSR_NAME}\n\n"
                                sleep 3
                                CheckEnv

		sleep 3

		CheckEnv
}


Create_Multi_CSR() {


openssl genrsa -out KEY/${1}.key 4096
openssl req -new -key KEY/${1}.key -out CSR/${1}.csr -config SAN-CERT.conf

}

List_CSRs() {
}

List_CSR_Content() {
}

Create_Backup_CSR() {
}

######### Execute #########
#
CheckEnv

