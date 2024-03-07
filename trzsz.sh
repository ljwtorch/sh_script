sudo apt install curl gpg -y
wget http://pan.witter.top/p/armored-keys.asc | cat armored-keys.asc \
    | gpg --dearmor -o /usr/share/keyrings/trzsz.gpg
echo 'deb [signed-by=/usr/share/keyrings/trzsz.gpg] https://ppa.launchpadcontent.net/trzsz/ppa/ubuntu jammy main' \
    | sudo tee /etc/apt/sources.list.d/trzsz.list
sudo apt update
sudo apt install trzsz -y