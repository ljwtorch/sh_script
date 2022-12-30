#!/bin/bash
# 设置mysql变量
container_name="mysql"
mysql_user="root"
mysql_password="lijuwei"
mysql_host="localhost"
mysql_port="3306"
mysql_database="wordpress"
backup_dir="/home/torch/backup_all/mysql_backup"

# 是否删除旧数据
delete_old_backup="true"
backup_days=3
backup_time=`date +%Y%m%d%H%M`

# 运行备份指令
docker exec $container_name mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $mysql_database > "$backup_dir"/"backup-$mysql_database-$backup_time.sql"

# 删除指定天数前的备份文件
if [ "$delete_old_backup" == "true" ]
then
    `find $backup_dir -type f -ctime +$backup_days | xargs sudo rm -r`
fi

# crontab
# 0 2 * * * /home/torch/software/sh_script/mysql_backup.sh