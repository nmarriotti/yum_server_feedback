#!/bin/bash

log=reposync-el6.log
send_log=/var/log/reposync.log

# Clear yum cache to trigger network connection
rm -rf /var/cache/yum

# remove old log file
rm -f $log

reposync -g -l -d -m --repoid=base-6 --newest-only --download-metadata --download_path=/var/www/html/repos/el6 2>> $log

reposync -g -l -d -m --repoid=centosplus-6 --newest-only --download-metadata --download_path=/var/www/html/repos/el6 2>> $log

reposync -g -l -d -m --repoid=extras-6 --newest-only --download-metadata --download_path=/var/www/html/repos/el6 2>> $log

reposync -g -l -d -m --repoid=updates-66 --newest-only --download-metadata --download_path=/var/www/html/repos/el6 2>> $log

/bin/bash /scripts/createrepo-el6.sh

if [ -s $log ]; then
	cat $log
	echo "`date` reposync-el6: FAILED" >> $send_log
else
	echo "`date` reposync-el6: SUCCESS" >> $send_log
fi

chmod 644 $send_log

if [ `cat $send_log | wc -l` -gt 1 ]; then
	# File is ready for nifi
	mv -f $send_log /home/nifi/yum_reposync.log
	chown nifi:nifi /home/nifi/yum_reposync.log
fi

rm -f $log
