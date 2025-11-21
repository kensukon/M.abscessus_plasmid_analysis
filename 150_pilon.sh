#!/bin/bash
# polish assembly.fasta using pilon
# conda activate polish_pilon
# pilon 1.24.0
# bwa Version: 0.7.17-r1188
# samtools 1.13

REFSEQ=path_to_refseq/ATCC19977.fasta
DIR=path_to_assembly

# path to IonTorrent short read
IN_SHORT1=path_to_fastq_of_short_read1
IN_SHORT2=path_to_fastq_of_short_read2
IN_SHORT3=path_to_fastq_of_short_read3
IN_SHORT4=path_to_fastq_of_short_read4
IN_SHORT5=path_to_fastq_of_short_read5

# specify barcode name
id=(barcode01 barcode02 barcode03 barcode04 barcode05)

for item in ${id[@]}
do

OUT_DIR1=${DIR}${item}/pilon_1/
OUT_DIR2=${DIR}${item}/pilon_2/
OUT_DIR3=${DIR}${item}/pilon_3/

mkdir ${OUT_DIR1}
mkdir ${OUT_DIR2}
mkdir ${OUT_DIR3}

if [ ${item} = barcode01 ]; then
    IN_SHORT=${IN_SHORT1}
elif [ ${item} = barcode02 ]; then
    IN_SHORT=${IN_SHORT2}
elif [ ${item} = barcode03 ]; then
    IN_SHORT=${IN_SHORT3}
elif [ ${item} = barcode04 ]; then
    IN_SHORT=${IN_SHORT4}
elif [ ${item} = barcode05 ]; then
    IN_SHORT=${IN_SHORT5}
elif [ ${item} = barcode06 ]; then
    IN_SHORT=${IN_SHORT6}
fi

# 1st polish
# mapping
# index
bwa index ${DIR}${item}_5000/assembly.fasta
bwa mem -t 20 ${DIR}${item}_5000/assembly.fasta ${IN_SHORT} | samtools view -@ 20 -bS - > ${OUT_DIR1}${item}_aln.bam
#sort
samtools sort -@ 20 ${OUT_DIR1}${item}_aln.bam > ${OUT_DIR1}${item}_aln_sorted.bam
#index
samtools index ${OUT_DIR1}${item}_aln_sorted.bam
#polish
java -Xmx16G -jar path_to_pilon.jar/pilon.jar \
     --genome ${DIR}${item}/assembly.fasta \
     --unpaired ${OUT_DIR1}${item}_aln_sorted.bam \
     --vcf --changes --verbose --threads 20 --outdir ${OUT_DIR1}

# 2nd polish
# mapping
# index
bwa index ${OUT_DIR1}pilon.fasta
bwa mem -t 20 ${OUT_DIR1}pilon.fasta ${IN_SHORT} | samtools view -@ 20 -bS - > ${OUT_DIR1}${item}_aln.bam
#sort
samtools sort -@ 20 ${OUT_DIR1}${item}_aln.bam > ${OUT_DIR1}${item}_aln_sorted.bam
#index
samtools index ${OUT_DIR1}${item}_aln_sorted.bam
#polish
java -Xmx16G -jar ath_to_pilon.jar/pilon.jar \
     --genome ${OUT_DIR1}/pilon.fasta \
     --unpaired ${OUT_DIR1}${item}_aln_sorted.bam \
     --vcf --changes --verbose --threads 20 --outdir ${OUT_DIR2}

done