#!/bin/bash
# de novo assembly using flye
# conda activate assembly

OUT_DIR=path_to_outdir
INPUT_DIR=path_to_corrected_fasta

# specify barcode name
id=(barcode06)

for item in ${id[@]}
do

flye --nano-raw ${INPUT_DIR}${item}_fmlrc.fasta \
     --out-dir ${OUT_DIR}${item}/ \
     --threads 20 -i 1

mkdir ${OUT_DIR}${item}/quast/

quast ${OUT_DIR}${item}/assembly.fasta -R ${REFSEQ} -o ${OUT_DIR}${item}/quast/ -t 20
seqkit stats -a -G N ${OUT_DIR}${item}/assembly.fasta > ${OUT_DIR}${item}/assembly_result.txt

done