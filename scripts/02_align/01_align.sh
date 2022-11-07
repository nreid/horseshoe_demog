#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=50G
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-5]

hostname
date


# load software

module load minimap2/2.24
module load samtools/1.16.1

# input/output files, directories
INDIR=../../data/reads/
INFILE=$(find ${INDIR} -name "*q" | sort | sed -n ${SLURM_ARRAY_TASK_ID}p)

OUTDIR=../../results/alignments
    mkdir -p ${OUTDIR}

NPROC=$(nproc)
GENOME=../../data/genome/genome.fa

OUTROOT=$(echo ${INFILE} | sed 's/.*\///; s/\..*//')


# run minimap
minimap2 -c --MD -ax map-ont -t 10 ${GENOME} ${INFILE} | \
samtools sort -@ 5 -T ${OUTDIR}/${OUTROOT}.temp -O BAM \
>${OUTDIR}/${OUTROOT}.bam

samtools index ${OUTDIR}/${OUTROOT}.bam