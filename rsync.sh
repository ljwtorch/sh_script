#!/bin/bash

set -o errexit	#发生错误时立即退出shell
set -o nounset	#尝试使用未设置的变量时引发错误
set -o pipefail	#管道命令中，任一命令失败则整个管道命令标记为失败

readonly QL_DIR="/home/torch/hdd/qinglong"
readonly MYSQL_DIR="/home/torch/hdd/mysql"
readonly SOFTWARE_DIR="/home/torch/hdd/software"
readonly BACKUP_PATH="/mnt/king/rsync/"

sudo rsync -av --delete $QL_DIR $BACKUP_PATH
sudo rsync -av --delete $MYSQL_DIR $BACKUP_PATH
sudo rsync -av --delete --exclude='alist/alist_data/**' --exclude='*.log' $SOFTWARE_DIR $BACKUP_PATH
sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/hdd/biliup $BACKUP_PATH
sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/hdd/douyin $BACKUP_PATH
sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/hdd/live $BACKUP_PATH

cd /mnt/king/ && sudo tar zcvf rsync.tar.gz rsync/ && sudo cp rsync.tar.gz /mnt/infini/