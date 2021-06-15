## ENABLE UBUNTU REPO for KONG
```
echo "deb [trusted=yes] https://download.konghq.com/gateway-2.x-ubuntu-$(lsb_release -sc)/ default all" | sudo tee /etc/apt/sources.list.d/kong.list 
sudo apt-get update
sudo apt install -y kong
```
Update the home directory created by this install.
```
sudo cp -r /etc/skel/. /home/kong/.
sudo chown -R kong:kong /home/kong
sudo chmod -R go=u,go-w /home/kong/.
sudo chmod go= /home/kong
```

## DATABASE INSTALL on SYSTEM

By default, uses a local system account (ident role).  The installation procedure created a user account called postgres that is associated with the default Postgres role. In order to use Postgres, you can log into that account.
```
sudo apt-get install postgresql postgresql-contrib
```

Shell over the postgresql account
```
sudo -i -u postgres
```

Enter postgresql shell
```
psql
```

To exit the shell use \q
To access the shell without switching accounts
```
sudo -u postgres psql
```

## CONFIGURE DATABASE for KONG

### Create database objects
Create a user, database, and set password for the operating database
```
create user kong; create database kong OWNER kong; alter user kong passowrd '<yourpassword>';
```
### Configure kong for database installation
Copy the /etc/kong/kong.conf.default to /etc/kong/kong.conf
```
sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
```
Update file with postgreql options

Run the Kong migrations.  
Permission denied errors can be linked to non-sudo running of the command.  Unless you add postgresql to the sudoers, you will need to run as another user.
After running this, update the permissions to kong:kong on /usr/local/kong

```
sudo kong migrations bootstrap -c /etc/kong/kong.conf
sudo chown -Rf kong:kong /usr/local/kong
```

Verify tables installed (connect as kong)
```
\c kong
\dt
```

## CONFIGURE SYSTEM for KONG

### Update system limits for the daemon user: kong
We are using the system user kong to run the job.  ulimits need to be updated in /etc/security limits.  The number must exceed 4096 for kong.
```
kong		hard	nofile		8192
kong		soft	nofile		8192
```

Enable the changes
```
sudo sysctl -p
```

Switch to kong user and verify ulimits
```
sudo su - kong
ulimit -Sn
ulimit -Hn
```

### Confirm that kong can run

Startup kong and verify it is running
```
kong start -c /etc/kong/kong.conf
curl -i http://localhost:8001/
kong stop
curl -i http://localhost:8001/
```

### Configure system service
Setup the system job to start kong.  Create /etc/systemd/system/kong.service
Note: make sure to update DefaultLimitNOFILE to what you set in ulimits
```
[Unit]
Description="Kong service"
After=syslog.target network.target

[Service]
User=kong
Group=kong
Type=forking
ExecStart=/usr/local/bin/kong start -c /etc/kong/kong.conf
ExecStop=/usr/local/bin/kong stop 
ExecReload=/usr/local/bin/kong reload -c /etc/kong/kong.conf
ExecStop=/usr/local/bin/kong stop
DefaultLimitNOFILE=8196

[Install]
WantedBy=multi-user.target
```
Reload systemd, enable the service, start the service, and verify
```
sudo systemctl daemon-reload
sudo systemctl enable kong
sudo systemctl start kong
curl -i http://localhost:8001/
```


