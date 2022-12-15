#!/bin/bash 
#SBATCH --job-name=bases_per_window
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=general

hostname
date

# load required software

module load bedtools/2.29.0
module load bamtools/2.5.1
module load htslib/1.12
module load samtools/1.12

# define and/or create input, output directories
INDIR=../../results/coverage_stats

OUTDIR=../../results/diversity
    mkdir -p $OUTDIR

KB10=${OUTDIR}/limulus_10kb.bed
KB100=${OUTDIR}/limulus_100kb.bed

INCLUDEDBASES=../../results/coverage_stats/promethion_include_15_45_10bpmerge.bed.gz

# run bedtools coverage
bedtools coverage -a ${KB10} -b ${INCLUDEDBASES} | bgzip >${OUTDIR}/cov10kb.bed.gz
bedtools coverage -a ${KB100} -b ${INCLUDEDBASES} | bgzip >${OUTDIR}/cov100kb.bed.gz