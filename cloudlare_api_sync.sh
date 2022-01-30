#!/bin/bash

# Create a new API token just for DNS updates to the domain
email="<cf_login_email>"
api_token="<cf_api_token>"
zone="<cf_api_zoneid>"
record="<cf_recordid>"
# this can also be a subdomain home.domain.com
dns_name="<dns_name_to_update>"

# Pull the public facing IP address of the current site using Cloudflare
ip=`curl https://cloudflare.com/cdn-cgi/trace | awk -F 'ip=' 'NF>1{print $2}'`
# used for last value - current value comparison - prevents API call if unchanged - important
ip_file="/etc/cron.d/ip.txt"
# track the actions
log_file="/var/log/cloudflare/cloudflare.log"

# LOGGER
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $log_file
    fi
}

log "IP Assigned=[$ip]"

# SCRIPT START
log "Check Initiated"

if ! [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    message="Fetched IP does not look valid! Quitting"
    log "$message"
    echo -e "$message"
    exit 1 
fi

if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
    if [ $ip == $old_ip ]; then
        echo "IP has not changed."
	log "No change."
        exit 0
    fi
fi

# this makes the call to make the change using the variables set at the top
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone/dns_records/$record" -H "X-Auth-Email: $email " -H "X-Auth-Key: $api_token" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$dns_name\",\"content\":\"$ip\",\"ttl\":120}")

if [[ $update == *"\"success\":false"* ]]; then
    message="API UPDATE FAILED. DUMPING RESULTS:\n$update"
    log "$message"
    echo -e "$message"
    exit 1
else
    message="IP changed to: $ip"
    echo "$ip" > $ip_file
    log "$message"
    echo -e "$message"
fi
