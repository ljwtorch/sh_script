echo "Choose Your System: "
echo "1. Ubuntu"
echo "2. Debian"
echo "3. Linux With yum"
echo "4. Mac OS"
read -p "Please enter one of the 1-4 numbers: " choice

case $choice in
  1)
      sudo apt update && sudo apt install software-properties-common
      sudo add-apt-repository ppa:trzsz/ppa && sudo apt update
      sudo apt install trzsz
  ;;
  2)
      sudo apt install curl gpg -y
      wget http://pan.witter.top/p/armored-keys.asc
      cat armored-keys.asc | gpg --dearmor -o /usr/share/keyrings/trzsz.gpg
      echo 'deb [signed-by=/usr/share/keyrings/trzsz.gpg] https://ppa.launchpadcontent.net/trzsz/ppa/ubuntu jammy main' \
          | sudo tee /etc/apt/sources.list.d/trzsz.list
      sudo apt update
      sudo apt install trzsz -y
  ;;
  3)
    echo '[trzsz]
    name=Trzsz Repo
    baseurl=https://yum.fury.io/trzsz/
    enabled=1
    gpgcheck=0' | sudo tee /etc/yum.repos.d/trzsz.repo
    sudo yum install trzsz
  ;;
  4)
    brew update
    brew install trzsz-go
  ;;
  *)
    echo "Invalid input !"
  ;;
esac
