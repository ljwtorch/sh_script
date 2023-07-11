#!/bin/bash

function replace_source_ubuntu() {
  read -p "Starting a backup of the original image source, Press Enter to continue..."
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
  sudo apt-get update
}

function replace_source_debian() {
  read -p "Starting a backup of the original image source, Press Enter to continue..."
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
  sudo apt-get update
}

function install_docker() {
  read -p "Uninstall all conflicting packages, Press Enter to continue..."
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

  read -p "Update the apt package index and install packages to allow apt to use a repository over HTTPS: "
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg

  read -p "Add Docker's official GPG key:, Press Enter to continue..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  read -p "Set up the repository, Press Enter to continue..."
  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  read -p "Install Docker Engine, Press Enter to continue..."
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo docker run hello-world

  read -p "Change Docker software source, Press Enter to continue..."
  echo '{ "registry-mirrors": ["https://mirror.nju.edu.cn/"] }' | sudo tee /etc/docker/daemon.json
  sudo systemctl daemon-reload
  sudo systemctl restart docker.service

  read -p "Install Docker Compose standalone? (y/n): " compose_judge
  compose_judge=${compose_judge,,}
  if [ "$compose_judge" == "y" ]; then
    echo "Installing Docker Compose..."
    # 在此处添加安装 Docker Compose 的指令
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo chmod 777 /usr/local/bin/docker-compose
  else
    echo "Skipping docker-compose installation."
  fi

  read -p "If you want add docker user group? (y/n): " dockergrp_judge
  dockergrp_judge=${dockergrp_judge,,}
  if [ "$dockergrp_judge" == "y" ]; then
    read -p "Type in your username, Press Enter to continue...: " username
    sudo groupadd docker               
    sudo gpasswd -a ${username} docker    
    newgrp docker 
  else
    echo "Skipping add docker user group."
  fi
}

function k8s_install() {
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
  sudo apt-mark hold kubelet kubeadm kubectl

  echo "开始添加 k8s 指令补全"
  sudo apt-get install bash-completion
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  source ~/.bashrc
  cat ~/.bashrc
  echo "已经添加 k8s 指令补全"
}

function k8s_uninstall() {
  sudo apt-get remove --purge kubernetes-cni kubelet kubeadm kubectl
  sudo rm -r /var/log/pods/*
  sudo rm -r ${HOME}/.kube/*
}

function helm_tab() {
  source <(helm completion bash)
  echo "已经添加 helm 指令补全"
}

function adduser() {
# check if user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# check if user already exists
if id "sonkwo" >/dev/null 2>&1; then
    echo "User sonkwo already exists"
    exit 1
fi

# create user on Debian
if [[ $(uname) == "Linux" ]] && [[ $(awk -F= '/^NAME/{print $2}' /etc/os-release) == "Debian" ]]; then
   adduser --disabled-password --gecos "" sonkwo
   echo "User sonkwo created"
   exit 0
fi

# create user on CentOS
if [[ $(uname) == "Linux" ]] && [[ $(awk -F= '/^NAME/{print $2}' /etc/os-release) =~ "CentOS" ]]; then
   useradd sonkwo
   echo "User sonkwo created"
   exit 0
fi

# print error message if unsupported OS
echo "Unsupported operating system"
exit 1
}

function aliasll() {
  echo "alias ll='ls -alh'" >> ~/.bashrc
  source ~/.bashrc
}

function speedTest() {
  sudo apt update
  sudo apt install iperf3 -y
}

echo "请选择要执行的操作："
echo "1. 更换 Ubuntu 软件源为USTC"
echo "2. 安装 Docker Engine"
echo "3. 安装 kubeadm kubectl kubelet"
echo "4. 卸载 kubeadm kubectl kubelet"
echo "5. 更换 Debian 软件源为USTC"
echo "6. 增加 helm 自动补全功能"
echo "7. 增加 sonkwo 普通用户"
echo "8. 增加 alias ll='ls -alh'"
echo "9. 安装 iperf3 内网测速工具"
read choice

case $choice in
  1)
    replace_source_ubuntu
    ;;
  2)
    install_docker
    ;;
  3)
    k8s_install
    ;;
  4)
    k8s_uninstall
    ;;
  5)
    replace_source_debian
    ;;
  6)
    helm_tab
    ;;
  8)
    aliasll
    ;;
  9)
    speedTest
    ;;
  *)
    echo "无效的选项"
    ;;
esac