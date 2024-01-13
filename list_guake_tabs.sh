#!/bin/bash
TAB_ARRAY=()
i=0

while [ "$(guake -s $i 2>&1)" = "" ]; do
    TAB_ARRAY+=("$(guake -l)")
    i=$((i + 1))
done

echo "${TAB_ARRAY[@]}"

# Specify the output file
output_file="/home/abhsss/.dotfiles/guake_tab_list.txt"

> "$output_file"

# Loop through the array and write index and element to the file
for i in "${!TAB_ARRAY[@]}"; do
    echo "$i ${TAB_ARRAY[$i]}" >>"$output_file"
done

echo "Array elements written to $output_file"
