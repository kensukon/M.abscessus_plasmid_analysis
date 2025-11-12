#!/bin/bash
# Mapping using BWA-MEM

#specify as appropriate for each analysis
REFSEQ=path_to_refseq
INPUT_DIR=path_to_fastq_file
OUT_DIR=path_to_outdir

mkdir ${OUT_DIR}

# make index for mapping
bwa index ${REFSEQ}

#specify sample name
id=(sample_name)

for item in ${id[@]}
do

echo "Mapping ${item} by BWA and sorting by samtools starts."

bwa mem -t 20 \
        -R "@RG\tID:${item}\tSM:${item}\tPL:iontorrent\tLB:${item}" \
        ${REFSEQ} \
        ${INPUT_DIR}${item}_1_100m.fastq.gz \
        ${INPUT_DIR}${item}_2_100m.fastq.gz \
        > ${OUT_DIR}${item}.sam

# label to mate pair
samtools sort -@ 20 -n -O sam ${OUT_DIR}${item}.sam | samtools fixmate -@ 20 -m -O bam - ${OUT_DIR}${item}_fixmate.bam
# convert to bam file and sort
samtools sort -@ 20 -O bam -o ${OUT_DIR}${item}_sorted.bam ${OUT_DIR}${item}_fixmate.bam

rm ${OUT_DIR}${item}_fixmate.bam

#mark duplicate
samtools markdup -@ 20 -r -S ${OUT_DIR}${item}_sorted.bam ${OUT_DIR}${item}_dedup.bam
#make index file
samtools index -@ 20 -b ${OUT_DIR}${item}_dedup.bam
rm ${OUT_DIR}${item}_sorted.bam
#samtools view -h -b -q 20 ../result/bwa/100X/${item}_dedup.bam > ../result/bwa/100X/${item}_dedup_q20.bam

echo "Mapping ${item} by BWA and conversion to bam format files finished!"

# caluculate mapping statics
samtools flagstat -@ 20 ${OUT_DIR}${item}_dedup.bam > ${OUT_DIR}${item}_mapping_log.txt
samtools depth ${OUT_DIR}${item}_dedup.bam | gzip > ${OUT_DIR}${item}.depth.txt.gz

mkdir ${OUT_DIR}qualimap_result

# mapping result using qualimap
qualimap bamqc -outdir ${OUT_DIR}qualimap_result -outfile ${item}_dedup_report.pdf -bam ${OUT_DIR}${item}_dedup.bam 

done