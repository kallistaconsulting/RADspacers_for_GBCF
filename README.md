# RADspacers_for_GBCF
Removing custom spacers for the RAD library protocol April 2025

## Overview
Library Structure:

P5-TruSeqRead1-EcoRInlinebarcode-EcorIcutsite-insert-MseIcutsite-[spacer]-SamplebarcodeTruSeqRead2-P7

<b>Goal</b>: Create a means to remove the technical artifacts added to the read insert for RADseq libraries
using our custom spacers. The library structure above has the traditional sequencer adapters in cool
colors (sequencing adapters and sample barcode). These are all handled by the sequencer postprocessing that normally happens within the sequencing run. The warm colors are the sections we need
to custom clean up (in-line barcode on the EcoRI side and the custom spacer on the MseI side).

<b>Workflow to pre-clean</b>:

 0 – automatic clean up by sequencer, these are the files we start with
 returns: EcoRInlinebarcode-EcorIcutsite-insert-MseIcutsite-[spacer]
 
 1 – remove spacer
 returns: EcoRInlinebarcode-EcorIcutsite-insert-MseIcutsite
 
 2 – split samples by barcode
 returns: EcorIcutsite-insert-MseIcutsite

<b>Considerations</b>: It is preferred that this processing can be done by the client when possible. Using
established software to perform steps is therefore preferred. 

## Removing Spacers
Cutadapt was selected as the clean-up software as it allows for custom input and defined mismatch
handling.

<b>Required files</b>: 
* spacers.fasta – a file that has all of the spacer sequences the core uses
* Example1_R1_001.fastq.gz
* Example1_R2_001.fastq.gz

<b>Command:</b>

<code>cutadapt -g file:spacers.fa -e 1 -o Example1_R2_001.nospacer.fastq.gz -p Example1_R1_001.nospacer.fastq.gz Example1_R2_001.fastq.gz Example1_R1_001.fastq.gz > Example1_spacer_rm.log</code>

Note the order is deliberate – read 2 should be input first and should be output first. This has no impact
on the files or reads other than to assist in removing the 3’ spacer. This can be done with parameters,
but this was easier and required fewer parameters.

## Demultiplexing individual EcoRI barcodes

Cutadapt was used again for this step, for simplicity.

<b>Required files</b>: 
* Barcode.fasta (barcodes fasta for the run - provided by user)
* Example1_R1_001.nospacer.fastq.gz – from previous step
* Example1_R2_001.nospacer.fastq.gz – from previous step

<b>Command</b>:

<code>cutadapt -g ^file:Barcode.fasta -o Example1_{name}.1.fastq.gz -p Example1_{name}.2.fastq.gz --no-indel Example1_R1_001.nospacer.fastq.gz Example1_R2_001.nospacer.fastq.gz > Example1_barcode_rm.log</code>

{name} will be replaced with the barcode name from the Barcode.fasta.

## Usage note
Place fastqs and above spacer reference fastas in the same location. Use the loopExample.sh code file to help set up your clean up.
<b>Please note, this does not do quality control</b> – after removing the spacer sequences and splitting the
files into their individual samples, please proceed with normal quality control filters for length, quality,
contamination, etc.
