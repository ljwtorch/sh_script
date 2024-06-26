#!/bin/bash

set -o errexit	#发生错误时立即退出shell
set -o nounset	#尝试使用未设置的变量时引发错误
set -o pipefail	#管道命令中，任一命令失败则整个管道命令标记为失败

#readonly QL_DIR="/home/torch/software/qinglong"
#readonly MYSQL_DIR="/home/torch/software/mysql"
readonly SOFTWARE_DIR="/home/torch/software/"
readonly BACKUP_PATH="root@pve:/mnt/ssd/software/"

sudo rsync -av --delete --exclude='alist/alist_data/**' --exclude='lubo/live/Videos/**' --exclude={'*.log','*.flv','*.flv.part'} $SOFTWARE_DIR $BACKUP_PATH
#sudo rsync -av --delete $QL_DIR $BACKUP_PATH
#sudo rsync -av --delete $MYSQL_DIR $BACKUP_PATH
#sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/software/biliup $BACKUP_PATH
#sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/software/douyin $BACKUP_PATH
#sudo rsync -av --delete --exclude={'*.log','*.flv','*.flv.part'} /home/torch/software/live $BACKUP_PATH

#cd /mnt/king/ && sudo tar zcvf rsync.tar.gz rsync/ && sudo cp rsync.tar.gz /mnt/infini/
