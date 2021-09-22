Creating a system account for features like discovery requires actions to remove the account from the interactive login screen on desktop machines.

On Ubuntu:
```
vi /var/lib/AccountsService/users/<username>
```
Contents of the file:
```
[User]
SystemAccount = true
```
If the file already exists, just append this line.
