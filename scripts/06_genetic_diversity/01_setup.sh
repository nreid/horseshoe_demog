#!/bin/bash 
#SBATCH --job-name=setup
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

# load software
module load bedtools/2.29.0
module load bamtools/2.5.1
module load htslib/1.12
module load samtools/1.12

# files/directories
OUTDIR=../../results/diversity
    mkdir -p ${OUTDIR}

# genome index file from samtools faidx
FAI=../../data/genome/genome.fa.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=$OUTDIR/limulus.genome
cut -f 1-2 $FAI > $GFILE


# make 10kb window bed file, slid 10kb, set variable for location
WIN10KB=$OUTDIR/limulus_10kb.bed
bedtools makewindows -g $GFILE -w 10000 >$WIN10KB

# make 100kb window bed file, set variable for location
WIN10KB=$OUTDIR/limulus_100kb.bed
bedtools makewindows -g $GFILE -w 100000 -s 10000 >$WIN10KB
