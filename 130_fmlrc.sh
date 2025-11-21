#!/bin/bash
# correct Nanopore read using Ion proton short read by fmlrc
# conda create -n error_correction fmlrc msbwt ropebwt2
# conda activate error_correction

# IonTorrent short readのpath
IN_SHORT1=path_to_fastq_of_short_read1
IN_SHORT2=path_to_fastq_of_short_read2
IN_SHORT3=path_to_fastq_of_short_read3
IN_SHORT4=path_to_fastq_of_short_read4
IN_SHORT5=path_to_fastq_of_short_read5

# Sprcify barcode
id=(barcode05 barcode04 barcode03 barcode04 barcode05)

for item in ${id[@]}
do

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

LONG_READ=path_to_long_read_fastq/${item}/${item}_filtered.fastq.gz
IN_LONG=path_to_long_read_fastq/${item}/${item}_filtered.fasta
OUT_FILE=path_to_long_read_fastq/${item}/${item}_fmlrc.fasta

gunzip -c ${LONG_READ} | awk '(NR - 1) % 4 < 2' | sed 's/@/>/' > ${IN_LONG}

cd path_to_long_read_fastq/${item}/
OUT_DIR=path_to_long_read_fastq/${item}/output2/

awk 'NR % 4 == 2' ${IN_SHORT} | sort | tr NT TN | ropebwt2 -LR | tr NT TN | msbwt convert output2

fmlrc ${OUT_DIR}comp_msbwt.npy ${IN_LONG} ${OUT_FILE}

done
