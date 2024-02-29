#!/bin/bash

spawn-fcgi -a 127.0.0.1 -p 9000 -u www-data -f /script/only_run.sh

nginx -c /etc/nginx/nginx.conf

# 要执行的命令或脚本
command_to_execute="/script/only_run.sh"

while true; do
  # 执行命令或脚本
  $command_to_execute

  # 等待一分钟
  sleep 60
done

