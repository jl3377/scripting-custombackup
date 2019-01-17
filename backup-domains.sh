#################################################################
# SERVER CONFIGURATION
##################################################################
SERVIDOR=artegrafico.net
DATE=$(date +"%Y-%m-%d")_$(date +"%H-%M") # mm-dd-yyyy-hh.mm.ss
EMAIL=seguridad@merkasi.es
SUBJECT="Backup WEBS"

#################################################################
# FTP DATA
##################################################################
NCFTP="/usr/bin/ncftpput"
FTP=yourdomainftp
FTP_USUARIO=youruser
FTP_CLAVE=yourpassword

#################################################################
# FTP DATA
##################################################################
DOMAINS_DIR=/var/www/vhosts/
DOMAINS_DIRECTORIES="/home/backup/domains.lst"
BACKUP_TMP=/home/backup/tmp
BACKUP_DIR=backups.artegrafico.net

#################################################################
# Backup Process
##################################################################

IFS='|' # lines separator
LINES=$(wc -l < $DOMAINS_DIRECTORIES)
z=1

while read -r domain dirs 
do
    	
    echo "######################################################"
    echo "$z/$LINES Backup from domain ..." $domain
    echo "######################################################"
    
    # process for read directories       
    for dir in $dirs;
    do

	# directory to prepare tar.gz file
        DIR_COPY=$DOMAINS_DIR$domain/$dir
        echo "Preparing to copy .... $DIR_COPY ..." 
	
	# temporary directory and name of file
	FILE=$BACKUP_TMP/$DATE-$domain-$dir.tar.gz
	echo "preparing backup file ..." $FILE
	
	# compress file
	tar -czf $FILE $DIR_COPY

	# send file to ftp
	$NCFTP -m -u $FTP_USUARIO -p $FTP_CLAVE $FTP $BACKUP_DIR/$domain/$dir $FILE
	
	# delete temporary file
	rm -f $FILE  

    done
    z=$((z+1))


done <$DOMAINS_DIRECTORIES

