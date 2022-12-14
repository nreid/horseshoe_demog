#!/bin/bash
#SBATCH --job-name=minimap_rebasecall
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=50G
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software

module load minimap2/2.24
module load samtools/1.16.1

# input/output files, directories
INDIR1=../../data/rebasecalled_reads/blood/pass/
INDIR2=../../data/rebasecalled_reads/muscle/pass/

OUTDIR=../../results/alignments
    mkdir -p ${OUTDIR}

NPROC=$(nproc)
GENOME=../../data/genome/genome.fa

OUTROOT=rebasecall


# run minimap
(
find ${INDIR1} -name "*fastq" -exec cat {} \;
find ${INDIR2} -name "*fastq" -exec cat {} \;
) | \
minimap2 -c --MD -ax map-ont -t 10 ${GENOME} /dev/stdin | \
samtools sort -@ 5 -T ${OUTDIR}/${OUTROOT}.temp -O BAM \
>${OUTDIR}/${OUTROOT}.bam

samtools index ${OUTDIR}/${OUTROOT}.bam