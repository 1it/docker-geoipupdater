#!/bin/bash

geoIPConf=${GeoIP_Conf:-/etc/GeoIP.conf}

### GeoIP
cat <<EOF > "$geoIPConf"
AccountID ${GeoIP_AccountID:-000000}

LicenseKey ${GeoIP_LicenseKey:-null}

EditionIDs GeoLite2-Country GeoLite2-City

DatabaseDirectory ${GeoIP_DatabaseDirectory:-/usr/share/GeoIP}

Host ${GeoIP_Host:-updates.maxmind.com}

PreserveFileTimes ${GeoIP_PreserveFileTimes:-0}

# LockFile /usr/share/GeoIP/.geoipupdate.lock

EOF

if [ ! -z "$GeoIP_Proxy" ]; then
    # Proxy 127.0.0.1:8888
    printf "Proxy ${GeoIP_Proxy}\n" >> $geoIPConf
fi

if [ ! -z "$GeoIP_ProxyUserPassword" ]; then
    # ProxyUserPassword username:password
    printf "ProxyUserPassword ${GeoIP_ProxyUserPass}\n" >> $geoIPConf
fi

# Try update
/usr/bin/geoipupdate -v 

### CRON

# Example
# declare -a JOBS_LIST="*/30 * * * * root /usr/bin/geoipupdate -v" 
#                      "* 3 * * * root /usr/bin/geoipupdate" 
#                      "30 1 * * 7 root /usr/bin/geoipupdate"

STDOUT=${STDOUT:-/proc/1/fd/1}
STDERR=${STDERR:-/proc/1/fd/2}

# Default job
printf "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin\n" > /etc/cron.d/jobs
# Weekly GeoIP Update
printf "30 5 * * 4 root /usr/bin/geoipupdate > $STDOUT 2>$STDERR \n" >> /etc/cron.d/jobs

declare -a JOBS
eval "JOBS=($JOBS_LIST)"

if [ ! -z "$JOBS" ]; then
    for i in "${JOBS[@]}"; do
        printf "$i > $STDOUT 2>$STDERR \n" >> /etc/cron.d/jobs;
    done
else
    echo 'No jobs found'
fi

# Show jobs
cat /etc/cron.d/jobs

exec $@
