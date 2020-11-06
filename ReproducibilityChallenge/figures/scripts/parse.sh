#!/bin/bash
FILE=$1

av_gflops=$(grep -E 'avGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
av_bw=$(grep -E 'av: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_bw=$(grep -E 'tot: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

proj_ktime=$(grep -E ' proj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $1}')
proj_ctime=$(grep -E ' proj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $2}')
proj_rtime=$(grep -E ' proj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $3}')

backproj_ktime=$(grep -E ' backproj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $3}')
backproj_ctime=$(grep -E ' backproj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $2}')
backproj_rtime=$(grep -E ' backproj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}' | awk '{print $1}')


echo $av_gflops,$tot_gflops,$av_bw,$tot_bw,$tot_time,$proj_ktime,$proj_ctime,$proj_rtime,$backproj_ktime,$backproj_ctime,$backproj_rtime