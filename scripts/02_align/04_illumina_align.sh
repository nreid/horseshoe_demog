#!/bin/bash 
#SBATCH --job-name=align_illumina
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load required software
module load samtools/1.12
module load samblaster/0.1.24
module load bwa/0.7.17

# raw data directory
INDIR=../../results/trimmed_illumina

# specify and create output directory
OUTDIR=../../results/alignments
mkdir -p $OUTDIR

# set a variable 'GEN' that gives the location and base name of the reference genome:
GEN=../../data/genome/limulus_index

# execute the pipe for the son:
bwa mem -t 7 -R '@RG\tID:limulus\tSM:limulus' $GEN $INDIR/SRR4181534_trim_1.fastq $INDIR/SRR4181534_trim_2.fastq | \
samblaster | \
samtools view -S -h -u - | \
samtools sort -T /scratch/$USER - >$OUTDIR/limulus_illumina.bam
date