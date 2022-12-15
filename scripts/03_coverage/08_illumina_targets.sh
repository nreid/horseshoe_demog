#!/bin/bash 
#SBATCH --job-name=ill_exclude
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

# input/output
INDIR=../../results/coverage/
OUTDIR=../../results/coverage/

# genome index file from samtools faidx
FAI=../../data/genome/genome.fa.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=${OUTDIR}/limulus.genome
cut -f 1-2 ${FAI} > ${GFILE}

PERBASE=${INDIR}/illumina_per_base.txt.gz

# pipe:

zcat ${PERBASE} | \
    awk '{OFS="\t"}{start=$2-1}{print $1,start,$2,$3}' | \
    awk '$4 > 25 && $4 < 80' | \
    bedtools merge -i stdin -c 4 -o count | \
    bgzip >${OUTDIR}/illumina_include_25_80.bed.gz

tabix -p bed ${OUTDIR}/illumina_include_25_80.bed.gz

# merge windows < 10bp apart
zcat ${OUTDIR}/illumina_include_25_80.bed.gz | \
    bedtools merge -i stdin -d 10 -c 4 -o count,sum | \
    awk '{OFS="\t"}{print $0,$3-$2}' | \
    awk '$6 > 1000' | \
    bgzip >${OUTDIR}/illumina_include_25_80_10bpmerge.bed.gz

tabix -p bed ${OUTDIR}/illumina_include_25_80_10bpmerge.bed.gz

# get complement
bedtools complement \
    -i ${OUTDIR}/illumina_include_25_80_10bpmerge.bed.gz \
    -g ${GFILE} | \
    bgzip >${OUTDIR}/illumina_exclude_25_80_10bpmerge.bed.gz

# also create an exclude file for > 1000x coverage
zcat ${PERBASE} | \
    awk '{OFS="\t"}{start=$2-1}{print $1,start,$2,$3}' | \
    awk '$4 > 1000' | \
    bedtools merge -i stdin -c 4 -o count | \
    bgzip >${OUTDIR}/illumina_exclude_1000x.bed.gz

tabix -p bed ${OUTDIR}/illumina_exclude_1000x.bed.gz