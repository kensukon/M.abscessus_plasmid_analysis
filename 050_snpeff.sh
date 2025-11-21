#!/bin/bash
# conda activate voi
INPUT_DIR=path_to_freebayes_file
OUT_DIR=path_to_out_dir

mkdir ${OUT_DIR}

id=(sample_name)

# make database

# nano snpeff.config
## search the below section
###############################################################################
#-------------------------------------------------------------------------------
# Databases & Genomes
#
# One entry per genome version.
#
# For genome version 'ZZZ' the entries look like
#   ZZZ.genome              : Real name for ZZZ (e.g. 'Human')
#   ZZZ.reference           : [Optional] Comma separated list of URL to site/s Where information for building ZZZ database was extracted.
#   ZZZ.chrName.codonTable  : [Optional] Define codon table used for chromosome 'chrName' (Default: 'codon.Standard')
#
#-------------------------------------------------------------------------------
################################################################################
# add the below sentence just after above section
# Abs1.genome : Abs1


# java -Xmx8g -jar path_to_snpEff.jar/snpEff.jar build -c path_to_snpEff.jar/snpEff.config -genbank -v Abs1


for item in ${id[@]}
do

mkdir ${OUT_DIR}${item}/

java -Xmx8g -jar path_to_snpEff.jar?snpEff.jar -v Isolate57625 ${INPUT_DIR}${item}/${item}_freebayes.filterd.vcf.gz \
      > ${OUT_DIR}${item}/${item}_freebayes_filtered_anno.vcf


bcftools query -H -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%FILTER\t%INFO\t%FORMAT\t%TYPE\t%ANN\n' \
         ${OUT_DIR}${item}/${item}_freebayes_filtered_anno.vcf \
         -o ${OUT_DIR}${item}/${item}_freebayes_filtered_anno.csv

done