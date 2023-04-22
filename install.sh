#!/bin/bash

function replace_source() {
    sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
    sudo apt-get update
}

function install_docker() {
    echo "Update the apt package index and install packages to allow apt to use a repository over HTTPS:"
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg

    echo "Add Docker’s official GPG key:"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "Use the following command to set up the repository:"
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "Install Docker Engine:"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world


    echo '{ "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"] }' | sudo tee /etc/docker/daemon.json
    sudo systemctl daemon-reload
    sudo systemctl restart docker.service

}

function k8s_install() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
    sudo apt-mark hold kubelet kubeadm kubectl
}

function k8s_uninstall() {
    sudo apt-get remove --purge kubernetes-cni kubelet kubeadm kubectl
    sudo rm -r /var/log/pods/*
    sudo rm -r ${HOME}/.kube/*
}

function k8s_tab() {
    sudo apt-get install bash-completion
    echo "source <(kubectl completion bash)" >> ~/.bashrc
    source ~/.bashrc
    cat ~/.bashrc
}

echo "请选择要执行的操作："
echo "1. 更换 Ubuntu 软件源为USTC (首次执行请先执行 sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak)"
echo "2. 安装 Docker Engine"
echo "3. 安装 kubeadm kubectl kubelet"
echo "4. 卸载 kubeadm kubectl kubelet"
echo "5. 增加 k8s 自动补全功能"
read choice

case $choice in
  1)
    replace_source
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
    k8s_tab
    ;;
  *)
    echo "无效的选项"
    ;;
esac