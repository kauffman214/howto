# ssmtp is a simple replacemnt for sending SMTP based E-mails through another E-mail provider (e.g. GMail)
# This will remove Postfix on Ubuntu
# To get the system to use the ssmtp gateway, mailx will also need to be configured to send the right values when it is called so SSMTP can act appropriately.
# bsd-mailx is the default on ubuntu 20 LTS and Should be installed already

```
sudo apt-get install ssmtp bsd-mailx
```

When using E-mail gateways, they typically want the from address for authentication purposes.  SSMTP calls will fail in most cases if the value is not set.

Edits to make:
```
sudo vi /etc/ssmtp/ssmtp.conf
```
For Apple.   Log in to your account and set up an App Password for mail.
The CRT is required. 
```
mailhub=smtp.mail.me.com:587
useSTARTTLS=YES
AuthUser=<apple.email.address>
AuthPass=<apple.app.password>
TLS_CA_FILE=<path.to>/ca.crt
rewriteDomain=me.com
FromLineOverride=YES
```
Test:
```
sudo ssmtp -vvv <to.user.email> subject:<subject>
or
echo "test message from linux server using ssmtp" | sudo ssmtp -vvv <to.email.address> subject:<subject>
```
Once this works, configure mailx to use the default from address.
```
sudo vi /etc/mail.rc
```
Add a line so that the SMTP provider will lookup the FROM. 
```
set from="<from.mail.account>"
```
Testing the configuration.  This should send the request to ssmtp.
```
# simple
mail --subject="<subject line>" <to_user@example.com>

# with body message content from file
mail --subject="<$HOSTNAME filename.txt>" <to_user@example.com> < <path/to/filename.txt>

# attach a file
tar cvzf - <path/to/directory1 path/to/directory2> | uuencode <data.tar.gz> | mail --subject="<subject_line>" <to_user@example.com>
```

