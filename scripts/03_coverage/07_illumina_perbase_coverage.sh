#!/bin/bash 
#SBATCH --job-name=ill_per_base_coverage
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
INDIR=../../results/alignments
OUTDIR=../../results/coverage
	mkdir -p ${OUTDIR}

# make bam list

BAMLIST=${OUTDIR}/bams.list
find ${INDIR} -name "SRR*bam" >${BAMLIST}

# genome index file from samtools faidx
FAI=../../data/genome/genome.fa.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=${OUTDIR}/limulus.genome
cut -f 1-2 $FAI > ${GFILE}

# window bed files
WIN1KB=${OUTDIR}/limulus_1kb.bed
bedtools makewindows -g ${GFILE} -w 1000 >${WIN1KB}
WIN10KB=${OUTDIR}/limulus_10kb.bed
bedtools makewindows -g ${GFILE} -w 10000 >${WIN10KB}

#--------------------------------

# calculate per-base coverage	
bamtools merge -list ${BAMLIST} |
samtools depth -a -d 20000 -Q 30 /dev/stdin | \
bgzip >${OUTDIR}/illumina_per_base.txt.gz

#---------------------------------

# summarize per-base coverage in 1kb windows
zcat ${OUTDIR}/illumina_per_base.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a ${WIN1KB} \
-b stdin \
-c 4 -o mean,median,sum,count \
-g ${GFILE} | \
bgzip >${OUTDIR}/illumina_per_base.1kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed ${OUTDIR}/illumina_per_base.1kb.bed.gz

#--------------------------

# summarize per-base coverage in 10kb windows
zcat ${OUTDIR}/illumina_per_base.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a ${WIN10KB} \
-b stdin \
-c 4 -o mean,median,sum,count \
-g ${GFILE} | \
bgzip >${OUTDIR}/illumina_per_base.10kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed ${OUTDIR}/illumina_per_base.10kb.bed.gz

date

