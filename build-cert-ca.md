Setting up a CA on a Ubuntu 20 LTS server

```
sudo apt-get install easy-rsa
dpkg --list easy-rsa
cd 
sudo make-cadir pki
cd pki
sudo vi vars
```
```
export KEY_COUNTRY="US"
export KEY_PROVINCE="VA"
export KEY_CITY="Herndon"
export KEY_ORG="Galvoti LLC"
export KEY_EMAIL="ken.kauffman@me.com"
export KEY_OU="Technology Services"
export KEY_ALGO="ec"
export KEY_DIGEST="sha512"
```
Build the CA
```
ln -s openssl-1.0.0.cnf openssl.cnf
./build-ca
ls keys
```
Build Intermediate Key
```
./build-inter
```
Build certificate request and sign it
```
./build-key mycert
```

