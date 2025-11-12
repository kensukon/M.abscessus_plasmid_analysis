#!/bin/bash
#Adjust the size of fastq files to 100 Mbp using seqkit
#Use the following command to check the size of the fastq.gz file and save it to a file.
#seqkit stats path_to_fastq_file/*_fastp.fastq.gz > path_to_fastq_file/seqkit_result.txt

#specify as appropriate for each analysis
INPUT_DIR=path_to_fastq_file
OUT_DIR=path_to_outdir

#specify sample name
id=(sample_name)

for item in ${id[@]}
do

#make file name
FILE1="${INPUT_DIR}${item}_1_fastp.fastq.gz"
FILE2="${INPUT_DIR}${item}_2_fastp.fastq.gz"

# Refer to p.
p1=$(awk -v awkFILE1=${FILE1} '$1 == awkFILE1 { print $6 }' path_to_fastq_file/seqkit_result_re.txt)
p2=$(awk -v awkFILE2=${FILE2} '$1 == awkFILE2 { print $6 }' path_to_fastq_file/seqkit_result_re.txt)

seqkit sample -p ${p1} --rand-seed 11 ${FILE1}\
       > ${OUT_DIR}${item}_1_100m.fastq

seqkit sample -p ${p2} --rand-seed 11 ${FILE2}\
       > ${OUT_DIR}${item}_2_100m.fastq

pigz -p 16 ${OUT_DIR}${item}_1_100m.fastq
rm ${OUT_DIR}${item}_1_100m.fastq

pigz -p 16 ${OUT_DIR}${item}_2_100m.fastq
rm ${OUT_DIR}${item}_2_100m.fastq

done