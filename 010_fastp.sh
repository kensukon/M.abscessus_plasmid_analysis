#!/bin/bash
# quality check by fastp
# conda activate sratools

#Specify as appropriate for each analysis
INPUT_DIR=path_to_inputdir
OUT_DIR=path_to_outdir

#Make Output directory
mkdir ${OUT_DIR}

# Specify sample name
id=(sample_name)

for item in ${id[@]}
do

fastp -i ${OUT_DIR}${item}_1.fastq -I ${OUT_DIR}${item}_2.fastq -o ${OUT_DIR}${item}_1_fastp.fastq -O ${OUT_DIR}${item}_2_fastp.fastq
fastqc ${OUT_DIR}${item}_1_fastp.fastq ${OUT_DIR}${item}_2_fastp.fastq
pigz -p 16 ${OUT_DIR}${item}_1_fastp.fastq
pigz -p 16 ${OUT_DIR}${item}_2_fastp.fastq

done