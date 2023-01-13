#!/bin/bash
backup_time=`date +%Y%m%d%H%M`
backup_dir="/home/torch/log/koko_backup"

#执行koko日志脚本
cd /home/torch/go_code/koko_log && go run main.go

#备份koko日志并删除当前目录的koko.log (需要事先在当前目录创建koko_backup文件夹)
sudo cp /home/torch/log/koko.log "$backup_dir"/koko-$backup_time.log
echo "模拟删除"
sudo rm /home/torch/log/koko.log