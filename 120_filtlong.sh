#!/bin/bash
# Nanoporeでシークエンスしたデータの解析パイプライン
# Guppyでbasecall
# porechopでアダプタートリミング
# filtlongでリードをフィルタリング
# conda仮想環境をactivateしてから実行
# conda activate nanopore

OUT_DIR=path_to_out_dir1
OUT_DIR2=path_to_out_dir2
INPUT_DIR=path_to_fastq
mini_length=2000

mkdir ${OUT_DIR}
mkdir ${OUT_DIR2}

# Specify barcode name
id=(barcode name)

for item in ${id[@]}
do

mkdir ${INPUT_DIR}${item}/
mkdir ${OUT_DIR2}${item}_filtered_2000/

#adapter trimming
porechop -t 20 -i ${INPUT_DIR}${item}/${item}.fastq -o ${OUT_DIR}${item}/${item}_trimmed.fastq.gz

#filtering
filtlong --min_length ${mini_length} --keep_percent 90 --target_bases 500000000 ${OUT_DIR}${item}/${item}_trimmed.fastq.gzz | \
gzip > ${OUT_DIR}${item}/${item}_filterd.fastq.gz

# QC by NanoStat
NanoStat -t 20 --fastq ${OUT_DIR}${item}/${item}_filterd.fastq.gz -o ${OUT_DIR2}${item}_filtered_${mini_length}/ -n ${OUT_DIR2}${item}_filtered_${mini_length}/${item}_${mini_length}_nanostat_out.txt

# QC by NanoPlot
NanoPlot -t 20 --fastq ${OUT_DIR}${item}/${item}_filterd.fastq.gzz --loglength -o ${OUT_DIR2}${item}_filtered_${mini_length}/

done
