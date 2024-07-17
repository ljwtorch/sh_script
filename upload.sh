#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

echo "Please enter the year you want to upload:"
read -r year

if [ -z "$year" ]; then
  echo "Error: The year cannot be empty"
  exit 1
fi

# 定义文件名和 OSS 路径
filename="$1"
oss_path="sonkwo-log-bj/sonkwo-track/${year}/${filename}"

read -r "Continue？(y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Upload cancelled"
  exit 0
fi

# 使用 ossutil 上传文件
ossutil cp -c ~/.ossutilconfig $filename oss://$oss_path