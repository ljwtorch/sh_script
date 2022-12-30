#!bin/bash
# 设置mysql变量
container_name="mysql"
mysql_user="root"
mysql_password="lijuwei"
mysql_host="localhost"
mysql_port="3306"
mysql_database="wordpress"
backup_dir="/home/torch/backup_all"

# 是否删除旧数据
backup_old_delete="true"
backup_days=7
backup_time='date +%Y%m%d%H%M'

docker exec $container_name mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $mysql_database > $backup_dir/backup-$mysql_database-$backup_time.sql