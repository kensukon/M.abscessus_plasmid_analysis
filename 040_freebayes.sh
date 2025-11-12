#!/bin/bash
# variant calling using freebayes
# $ conda create --yes -n var samtools bamtools freebayes bedtools vcflib rtg-tools bcftools matplotlib
# $ conda activate var

#specify as appropriate for each analysis
REFSEQ=path_to_refseq
INPUT_DIR=path_to_dedup_bam_file
OUT_DIR=path_to_outdir

#specify sample name
id=(sample_name)

mkdir ${OUT_DIR}

samtools faidx ${REFSEQ}

for item in ${id[@]}
do

mkdir ${OUT_DIR}${item}

echo "Variant calling of ${item}!"

#Now we call variants and pipe the results into a new file
freebayes -p 1 \
          -f ${REFSEQ} \
          -b ${INPUT_DIR}/${item}_dedup.bam \
          > ${OUT_DIR}${item}/${item}_freebayes.vcf

# compress file
bgzip ${OUT_DIR}${item}/${item}_freebayes.vcf
# index
tabix -p vcf ${OUT_DIR}${item}/${item}_freebayes.vcf.gz

rtg vcfstats ${OUT_DIR}${item}/${item}_freebayes.vcf.gz > ${OUT_DIR}${item}/${item}_freebayes_vcf_rtg_stats.txt

bcftools stats -F ${REFSEQ} \
               -s - ${OUT_DIR}${item}/${item}_freebayes.vcf.gz \
               > ${OUT_DIR}${item}/${item}_freebayes.vcf.gz.stats

# use rtg vcfffilter
rtg vcffilter -q 30 -i ${OUT_DIR}${item}/${item}_freebayes.vcf.gz -o ${OUT_DIR}${item}/${item}_freebayes.q30.vcf.gz
rtg vcfstats ${OUT_DIR}${item}/${item}_freebayes.q30.vcf.gz > ${OUT_DIR}${item}/${item}_freebayes.q30_rtg_stats.txt

vcffilter -f "QUAL > 1 & QUAL / AO > 10 & SAF > 0 & SAR > 0 & RPR > 1 & RPL > 1" ${OUT_DIR}${item}/${item}_freebayes.vcf.gz | bgzip > ${OUT_DIR}${item}/${item}_freebayes.filterd.vcf.gz
rtg vcfstats ${OUT_DIR}${item}/${item}_freebayes.filterd.vcf.gz > ${OUT_DIR}${item}/${item}_freebayes.filterd_rtg_stats.txt

# index
tabix -p vcf ${OUT_DIR}${item}/${item}_freebayes.filterd.vcf.gz
# vcffileの情報をcsvfileとして書き出す
bcftools query -H -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%INFO\t%FORMAT\t%TYPE\n' \
               ${OUT_DIR}${item}/${item}_freebayes.filterd.vcf.gz \
               -o ${OUT_DIR}${item}/${item}_freebayes.filterd.vcf.csv

done