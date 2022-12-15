#!/bin/bash 
#SBATCH --job-name=ont_exclude
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
INDIR=../../results/coverage_stats/
OUTDIR=../../results/coverage_stats/

GFILE=${OUTDIR}/limulus.genome


BLOOD=rerun_rmv_contam_29MAY2019_HsC-male-blood_PAD59173_PRO002_LSK109-reads-pass.per_base.txt.gz
MUSCLE=rmv_contam_promethion_limulus_muscle_2019NOV13_Super_Accurate_18NOV21.per_base.txt.gz

# pipe:
    # sum per-base coverage for promethion runs
    # exclude < 18 and > 42
    # merge windows to get target regions

paste <(zcat ${INDIR}/${BLOOD}) <(zcat ${INDIR}/${MUSCLE}) | \
    awk '{OFS="\t"}{start=$2-1;cov=$3+$6}{print $1,start,$2,cov}' | \
    awk '$4 > 15 && $4 < 45' | \
    bedtools merge -i stdin -c 4 -o count | \
    bgzip >${OUTDIR}/promethion_include_15_45.bed.gz

tabix -p bed ${OUTDIR}/promethion_include_15_45.bed.gz

# merge windows < 10bp apart
zcat ${OUTDIR}/promethion_include_15_45.bed.gz | \
    bedtools merge -i stdin -d 10 -c 4 -o count,sum | \
    awk '{OFS="\t"}{print $0,$3-$2}' | \
    awk '$6 > 1000' | \
    bgzip >$OUTDIR/promethion_include_15_45_10bpmerge.bed.gz

tabix -p bed $OUTDIR/promethion_include_15_45_10bpmerge.bed.gz
