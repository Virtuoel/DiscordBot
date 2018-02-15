#!/bin/bash

curr_dir=$(pwd)

wget_path="${curr_dir}/temp"
conda_path="$HOME/anaconda3/bin"
input_path="${curr_dir}/inputs"
output_path="${curr_dir}/results"

[ -d ${input_path} ] || mkdir ${input_path}
[ -d ${output_path} ] || mkdir ${output_path}

typeset -i counter=$(cat counter.txt)
counter=$(echo "$counter+1" | bc)
echo "$counter" > "${curr_dir}/counter.txt"

[ -d ${wget_path} ] || mkdir ${wget_path}
wget $1 -P ${wget_path}
mv ${wget_path}/* ${input_path}/input_${counter}
rmdir ${wget_path}

[ -f "${curr_dir}/deep_dream.py" ] || wget https://raw.githubusercontent.com/fchollet/keras/master/examples/deep_dream.py
. ${conda_path}/activate deep
python deep_dream.py ${input_path}/input_${counter} ${output_path}/dream_${counter}
