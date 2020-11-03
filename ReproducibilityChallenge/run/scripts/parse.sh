#!/bin/bash
FILE=$1
tot_bw=$(grep -E 'tot: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

echo $tot_gflops,$tot_bw,$prep_time,$tot_time
#echo tot_gflops $tot_gflops
#echo tot_bw $tot_bw GB/s
#echo prep_time $prep_time
#echo tot_time $tot_time sec
