#!/bin/bash

# 要执行的命令或脚本
command_to_execute="/path/to/your/script.sh"

while true; do
  # 执行命令或脚本
  $command_to_execute

  # 等待一分钟
  sleep 60
done

