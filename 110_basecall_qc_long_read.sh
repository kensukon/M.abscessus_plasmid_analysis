#!/bin/bash
# basecall using Guppy
# QC by NanoSTat and NAnoPlot
# conda activate nanopore

OUT_DIR=path_to_out_dir
OUT_DIR2=path_to_out_dir2
#SCRIPT_DIR=/Volumes/kens5TBHD/myco/script/for_MAB2/
INPUT_DIR=path_to_fast5

# サンプル名を適宜指定する
id=(barcode)

mkdir ${OUT_DIR}

for item in ${id[@]}
do

# guppyによるbasecall
mkdir ${OUT_DIR}${item}/
mkdir ${OUT_DIR2}${item}/

guppy_basecaller --flowcell FLO-MIN106 --kit SQK-LSK109 \
                 --barcode_kits EXP-NBD104 --trim_barcodes \
                 --cpu_threads_per_caller 4 --num_callers 5 \
                 -i ${INPUT_DIR}${item}/  -s ${OUT_DIR}${item}/ -r


# QC using NanoStat
NanoStat --barcoded -t 20 --fastq ${OUT_DIR}*.fastq -o ${OUT_DIR2}${item}/

# QC using NanoPlot
NanoPlot -t 20 --fastq ${OUT_DIR}*.fastq --loglength -o ${OUT_DIR2}${item}/

done
