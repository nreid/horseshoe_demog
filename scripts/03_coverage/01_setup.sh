#!/bin/bash 
#SBATCH --job-name=setup
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=5G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load required software

module load bedtools/2.29.0
module load bamtools/2.5.1
module load htslib/1.12
module load samtools/1.12

# define and/or create input, output directories
INDIR=../../results/alignments
OUTDIR=../../results/coverage_stats
mkdir -p $OUTDIR

# genome index file from samtools faidx
FAI=../../data/genome/genome.fa.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=$OUTDIR/limulus.genome
cut -f 1-2 $FAI > $GFILE

# make 1kb window bed file, set variable for location
WIN1KB=$OUTDIR/limulus_1kb.bed
bedtools makewindows -g $GFILE -w 1000 >$WIN1KB

# make 1kb window bed file, set variable for location
WIN10KB=$OUTDIR/limulus_10kb.bed
bedtools makewindows -g $GFILE -w 10000 >$WIN10KB
