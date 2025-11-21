#!/bin/bash
# mapping using minimap2
# conda activate nanopore

REFSEQ=path_to_refseq/ATCC19977.fasta
OUT_DIR=path_to_out_dir
INPUT_DIR=path_to_fastq

# specify barcode name
id=(barcode01)

mkdir ${OUT_DIR}

for item in ${id[@]}
do

mkdir ${OUT_DIR}${item}/

minimap2 -t 20 -ax map-ont \
         ${REFSEQ} ${INPUT_DIR}${item}/pass/${item}/${item}_210816_all_guppy_hac_filterd.fastq.gz \
| samtools sort -@ 20 -m 4G -O BAM - > ${OUT_DIR}${item}/${item}_sorted.bam \
&& samtools index -@ 8 ${OUT_DIR}${item}/${item}_sorted.bam

done