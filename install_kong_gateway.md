UBUNTU REPO
```
echo "deb [trusted=yes] https://download.konghq.com/gateway-2.x-ubuntu-$(lsb_release -sc)/ default all" | sudo tee /etc/apt/sources.list.d/kong.list 
sudo apt-get update
sudo apt install -y kong
```


SUPPORTING DB (postgresql)
By default, uses a local system account (ident role).  The installation procedure created a user account called postgres that is associated with the default Postgres role. In order to use Postgres, you can log into that account.
```
sudo apt-get install postgresql postgresql-contrib
```
Shell over the postgresql account
````
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

Create a user and dataabse for the service
```
CREATE USER kong; CREATE DATABASE kong OWNER kong;
```

Copy the /etc/kong/kong.conf.default to /etc/kong/kong.conf
```
sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
```
Update file with postgreql options

Run the Kong migrations.  Permission denied errors can be linked to non-sudo running of the command.  Unless you add postgresql to the sudoers, you will need to run as another user.
```
sudo kong migrations bootstrap -c /etc/kong/kong.conf
```
