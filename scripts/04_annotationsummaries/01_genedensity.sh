#!/bin/bash
#SBATCH --job-name=genedensity
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=your.email@uconn.edu
#SBATCH --mem=10G
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
OUTDIR=../../results/annotationsummaries
    mkdir -p ${OUTDIR}

# genome index file from samtools faidx
FAI=../../data/genome/genome.fa.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=${OUTDIR}/limulus.genome
cut -f 1-2 ${FAI} > ${GFILE}

# get coding sequences
ANNOTATION=../../data/annotation/anno.gtf
CDS=${OUTDIR}/CDS.gtf
awk '$3 ~ /CDS/' ${ANNOTATION} | \
    bedtools sort -faidx ${FAI} -i stdin >${CDS}

KB1e5=${OUTDIR}/KB1e5.bed
bedtools makewindows -g ${GFILE} -w 100000 -s 10000 >${KB1e5}

KB1e6=${OUTDIR}/KB1e6.bed
bedtools makewindows -g ${GFILE} -w 1000000 -s 100000 >${KB1e6}

# run bedtools coverage
bedtools coverage -a ${KB1e5} -b ${CDS} | bgzip >${OUTDIR}/cdsdensity_kb1e5.bed.gz
bedtools coverage -a ${KB1e6} -b ${CDS} | bgzip >${OUTDIR}/cdsdensity_kb1e6.bed.gz