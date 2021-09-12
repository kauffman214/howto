## Creating an account for monitoring and management/ Ubuntu
Create the account id < 1000 as a system account.  An extra step is required to hide it from the user list of interactive logins.
It will be a login account using SSH keys.

```
useradd --create-home --system --shell </path/to/shell> --comment "Management Account" <username>
or
useradd -m -r -s </path/to/shell> -c "Management Account" <username>
```

Set the password on the account.  Remove password login later.  This is used for interactive setup.
```
passwd <username>
```

Hide the account from interactive login (for desktop/ gui machines)
```
sudo vi /var/lib/AccountsService/users/<username>
```
Add the following content.
```
[User]
XSession=
SystemAccount=true
```
Without reboot:
ALT-F2 end the letter r and hit enter to restart the login manager.  Log out and login to verify.

or:

Reboot


To remove the user:
```
userdel -r <username>
rm -v /var/lib/AccountsService/user/<username>
```
Restart session (ALT-F2 + r) or Reboot
 
