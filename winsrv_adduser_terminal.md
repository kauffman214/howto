Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

# for example, add [Serverworld] user
# [P@ssw0rd01] ⇒ the password you set (replace it you like)
# [PasswordNeverExpires] ⇒ set password never expire(if set default expiration, do not specify this option)
```
PS C:\Users\Administrator> New-LocalUser -Name "Serverworld" `
-FullName "Server World" `
-Description "Administrator of this Computer" `
-Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd01" -Force) `
-PasswordNeverExpires `
-AccountNeverExpires 
```
Name        Enabled Description
----        ------- -----------
Serverworld True    Administrator of this Computer

# add [Serverworld] user to [Administrators] group
```
PS C:\Users\Administrator> Add-LocalGroupMember -Group "Administrators" -Member "Serverworld" 
```

# verify
```
PS C:\Users\Administrator> Get-LocalUser -Name Serverworld 
```

Name        Enabled Description
----        ------- -----------
Serverworld True    Administrator of this Computer
```
PS C:\Users\Administrator> Get-LocalGroupMember -Group "Administrators" 
```
ObjectClass Name               PrincipalSource
----------- ----               ---------------
User        RX-7\Administrator Local
User        RX-7\Serverworld   Local

# if remove an user, do like follows
```
PS C:\Users\Administrator> Remove-LocalUser -Name "Serverworld" 
```
