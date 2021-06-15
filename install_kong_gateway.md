UBUNTU REPO
```
echo "deb [trusted=yes] https://download.konghq.com/gateway-2.x-ubuntu-$(lsb_release -sc)/ default all" | sudo tee /etc/apt/sources.list.d/kong.list 
sudo apt-get update
sudo apt install -y kong
```
