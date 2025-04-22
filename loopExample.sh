for f in *R1*.fastq.gz

do
 file=${f%_R1*}

 ####
 #1) Remove spacers from read 2 and output. NOTE: Read order is
 #swapped intentionally – enter read 2 information FIRST
 ####

 cutadapt \
 -g file:spacers.fa \
 -e 1 \
 -o ${file}_R2_001.nospacer.fastq.gz \
 -p ${file}_R1_001.nospacer.fastq.gz \
 ${file}_R2_001.fastq.gz \
 $f > ${file}_spacer_rm.log

 ####
 #2) Demultiplex based on sharkBarcode - output
 #e.g. TD-2800_UDP024_S3_GOM_793.1.fastq.gz
 ####

 cutadapt \
 -g ^file:sharkBarcode.fasta \
 -o ${file}_{name}.1.fastq.gz \
 -p ${file}_{name}.2.fastq.gz \
 --no-indels \
 ${file}_R1_001.nospacer.fastq.gz \
 ${file}_R2_001.nospacer.fastq.gz > ${file}_barcode_rm.log
done
