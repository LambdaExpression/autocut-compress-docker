#!/bin/bash


lock_file="/tmp/only_run.lock"
lock_file_expired=604800

function execute(){
	bash /script/autocut_run.sh
}

function delete_lock_file(){
	rm -rf $lock_file
}


# 文件的更新时间 参数：文件路径和时间秒
function check_file_update() {
  local file_path=$1
  local threshold=$2

  # 检查文件是否存在
  if [ ! -e "$file_path" ]; then
    echo "false"
    return 1
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
}

result=$(bash /script/check_file_update.sh $lock_file $lock_file_expired)
if [ "$result" == "true" ]; then
	delete_lock_file
fi

if [ -e $lock_file ]; then
	echo "已经执行中，结束本次任务"
	exit 1
fi


echo "" > $lock_file

echo "开始执行"
execute || delete_lock_file
delete_lock_file
