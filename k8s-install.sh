#!/bin/bash

echo "Do you want to install or uninstall Kubernetes? Type 'install' or 'uninstall' and press Enter."

read action

if [ "$action" == "install" ]; then
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubelet kubeadm kubectl
  sudo apt-mark hold kubelet kubeadm kubectl
elif [ "$action" == "uninstall" ]; then
  sudo apt-get remove --purge kubernetes-cni kubelet kubeadm kubectl
else
  echo "Invalid action. Please type 'install' or 'uninstall' and press Enter."
fi