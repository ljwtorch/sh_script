#!/bin/bash
backup_time=`date +%Y%m%d%H%M`
backup_dir="/home/torch/log/koko_backup"

#执行koko日志脚本
cd /home/torch/go_code/koko_log && /usr/local/go/bin/go run main.go

#备份koko日志并清空当前目录的koko.log防止重复内容推送 (需要事先在当前目录创建koko_backup文件夹)
sudo cp /home/torch/log/koko.log "$backup_dir"/koko-$backup_time.log

sudo echo "" > /home/torch/log/koko.log