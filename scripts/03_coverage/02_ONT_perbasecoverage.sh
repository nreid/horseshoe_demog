#!/bin/bash 
#SBATCH --job-name=coverage
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=5G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[1-5]


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
	mkdir -p ${OUTDIR}

# set bam file
BAM=$(find ${INDIR} -name "*bam" | sort | sed -n ${SLURM_ARRAY_TASK_ID}p)
OUTROOT=$(echo ${BAM} | sed 's/.*\///; s/\..*//')

# window bed files
WIN1KB=${OUTDIR}/limulus_1kb.bed
WIN10KB=${OUTDIR}/limulus_10kb.bed

#--------------------------------

# calculate per-base coverage	
samtools depth -a -d 20000 ${INDIR}/${BAM} | \
bgzip >${OUTDIR}/${OUTROOT}.per_base.txt.gz

#---------------------------------

# summarize per-base coverage in 1kb windows
zcat ${OUTDIR}/${OUTROOT}.per_base.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a ${WIN1KB} \
-b stdin \
-c 4 -o mean,median,sum,count \
-g ${GFILE} | \
bgzip >${OUTDIR}/${OUTROOT}.1kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed ${OUTDIR}/${OUTROOT}.1kb.bed.gz

#--------------------------

# summarize per-base coverage in 10kb windows
zcat ${OUTDIR}/${OUTROOT}.per_base.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a ${WIN10KB} \
-b stdin \
-c 4 -o mean,median,sum,count \
-g ${GFILE} | \
bgzip >${OUTDIR}/${OUTROOT}.10kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed ${OUTDIR}/${OUTROOT}.10kb.bed.gz



date

