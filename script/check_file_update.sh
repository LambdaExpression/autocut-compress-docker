#!/bin/bash

file_path=$1
threshold=$2

# 检查文件是否存在
if [ ! -e "$file_path" ]; then
  echo "false"
  exit 1
fi

# 获取文件的最后修改时间（以秒为单位）
file_mtime=$(stat -c %Y "$file_path")

# 获取当前时间（以秒为单位）
current_time=$(date +%s)

# 计算文件的更新时间与当前时间的差异
time_diff=$((current_time - file_mtime))

# 检查时间差是否大于阈值
if [ "$time_diff" -gt "$threshold" ]; then
  echo "true"
else
  echo "false"
fi










