#!/bin/bash

# 指定目录
directory="/autocut/video/auto"

# 导出指定目录
out_directory="/autocut/video/out"

# 定义要扫描的文件后缀列表 全局变量 file_extensions="mp4,xx,xx,xx"
file_extensions_array=(`echo $file_extensions | tr ',' ' '`)  # 可根据需要添加其他后缀

# 比较文件最后更新时间和当前时间差, 该变量改为使用全局变量
# auto_file_update_time_gt=600

# 启用 nullglob 选项，确保没有匹配文件时不保留通配符
shopt -s nullglob

for file_extension in "${file_extensions_array[@]}"; do
    # 扫描目录下的指定后缀文件，包括子目录
    find "$directory" -type f \( -name "*.$file_extension" \) -print0 | while IFS= read -r -d '' video_file; do
        # 获取文件名和不带后缀的文件名
        base_name=$(basename "$video_file")
        file_name="${base_name%.*}"
        extension="${base_name##*.}"

        # 获取相对路径,不包含文件名
        relative_path=$(realpath --relative-to="$directory" "$video_file")
        relative_path_name=$(echo $relative_path | sed "s/.$extension//")

        # 如果文件名结尾中包含 "_cut"，跳过处理
        if [[ "$file_name" == *"_cut" ]]; then
            continue
        fi

        # 比较文件最后更新时间和当前时间差
        result=$(bash /script/check_file_update.sh "$directory/${relative_path_name}.${extension}" $auto_file_update_time_gt)
        if [ "$result" == "false" ]; then
            continue
        fi

        # 如果同目录下没有同名的 .md 文件
        if [ ! -e "$directory/$relative_path_name.md" ]; then
            # 执行 autocut
            autocut -t "$directory/$relative_path_name.$extension" --whisper-model ${whisper_model}

            # 修改 .md 文件中的复选框
            sed -i '/< No Speech >/! s/\[ \]/[x]/' "$directory/$relative_path_name.md"
        fi

        # 如果同目录下有同名的 .md 文件，并且没有 “同名_cut.文件后缀” 和 “同名.end 
        if [ -e "$directory/${relative_path_name}.md" ] && [ ! -e "$directory/${relative_path_name}_cut.mp4" ] && [ ! -e "$directory/${relative_path_name}.end" ] ; then
            # 执行 autocut
            autocut -c "$directory/${relative_path_name}.${extension}" "$directory/${relative_path_name}.srt" "$directory/${relative_path_name}.md"
        fi


        # 如果同目录下没有同名的 .end 文件，并且有 “同名_cut.文件后缀”
        if [ ! -e "$directory/${relative_path_name}.end" ] && [ -e "$directory/${relative_path_name}_cut.mp4" ] ; then
            mkdir -p $(echo "$out_directory/${relative_path_name}_endEdg" | sed "s/\/${file_name}_endEdg//")
            # 执行 目录移动
            mv "$directory/${relative_path_name}_cut.mp4" "$out_directory/${relative_path_name}_cut.mp4" 
            echo "" > "$directory/${relative_path_name}.end"
        fi


        if [ ! -e "$out_directory/${relative_path_name}_cut.md" ]; then
            # 执行 autocut
            autocut -t "$out_directory/${relative_path_name}_cut.mp4" --whisper-model ${whisper_model}
            rm -rf "$out_directory/${relative_path_name}_cut.srt"
        fi
    done
done
