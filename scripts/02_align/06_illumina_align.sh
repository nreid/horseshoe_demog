#!/bin/bash
#SBATCH --job-name=align
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=20G
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[0-35]%5

echo `hostname`

#################################################################
# Align reads to genome
#################################################################
module load bwa/0.7.5a
module load samtools/1.12
module load samblaster

INDIR=../../results/trimmedseqs
OUTDIR=../../results/alignments
mkdir -p $OUTDIR

# this is an array job. 
	# one task will be spawned for each sample
	# for each task, we specify the sample as below
	# use the task ID to pull a single line, containing a single accession number from the accession list
	# then construct the file names in the call to hisat2 as below

INDEX=../../data/genome/limulus_index

ACCLIST=../../metadata/metadata.csv

NUM=$(expr ${SLURM_ARRAY_TASK_ID} + 1)

SAMPLE=$(tail -n +2 $ACCLIST | cut -f 1 -d "," | sed -n ${NUM}p)

RG=$(echo \@RG\\tID:$SAMPLE\\tPL:Illumina\\tPU:x\\tLB:x\\tSM:$SAMPLE)

# run bwa mem, sort compress
bwa mem -t 4 -R ${RG} ${INDEX} ${INDIR}/${SAMPLE}_trim_1.fastq.gz ${INDIR}/${SAMPLE}_trim_2.fastq.gz | \
	samblaster | \
	samtools view -S -h -u - | \
	samtools sort -@ 4 -T ${OUTDIR}/${SAMPLE} - \
	>${OUTDIR}/${SAMPLE}.bam

samtools index ${OUTDIR}/${SAMPLE}.bam
