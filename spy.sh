#!/bin/bash

######################################################################
#
# Author: Kangxu Liu
# Email: liukangxu1996@gmail.com
# Created Date: 2017-03-12
# Verison: v1.0.1
#
######################################################################
#
# Usage:
# ./spy.sh [username]
#
######################################################################
#
# History:
# v1.0.0: Initial version
# v1.0.1: Fix deletion not functioning when there is no result branch
#
######################################################################

username=$1

while test -z "$username"
do
    read -p "Please input student's username:" username
done

cd ~
git clone git@10.111.1.96:${username}-lab
cd ${username}-lab
clear

echo "+----------------------------------------------------------------+"
echo "|                           git branch                           |"
echo "+----------------------------------------------------------------+"
git branch -a

echo "+----------------------------------------------------------------+"
echo "|                            git log                             |"
echo "+----------------------------------------------------------------+"
git log --pretty=format:'%h by %an, %ar, message: %s' --graph --all

echo "================================"

result_branch_count=$(git branch -a | grep -o 'remotes/origin/lab[1-6]-result' | wc -l)
echo "${result_branch_count} result_branch has found."

if test $result_branch_count -ne 0; then
    read -p "Which lab you'd like to see?[1, ${result_branch_count}]" selected_branch

    if test $selected_branch -ge 1 -a $selected_branch -le $result_branch_count; then
        git checkout lab${selected_branch}-result
        cd log
        find -name "*.log" | sort -n -r > result_list

        log_count=$(cat result_list | wc -l)
        i=1

        for result in `cat result_list`
        do
            clear
            echo "+----------------------------------------------------------------+"
            echo "|                         Lab${selected_branch}  Log [${i}/${log_count}]                        |"
            echo "+----------------------------------------------------------------+"
            if file $result | grep -q "UTF-8"; then
                cat $result
            else
                iconv -f GBK -t UTF-8 $result
            fi
            i=$[$i+1]
            if test $i -le $log_count; then
                echo "================================"
                read -p "Press [Enter] to continue loading..."
            fi
        done
    else
        echo "[ERROR] Illegal input!"
    fi
fi

rm -rf ~/${username}-lab
