#!/bin/bash 
#SBATCH --job-name=heterozygous_sites_per_window
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
module load bcftools/1.16


# files/directories

OUTDIR=../../results/diversity
    mkdir -p ${OUTDIR}

VCF=../../results/variants_clair3/merge_sorted.vcf.gz

TARGETS=../../results/coverage_stats/promethion_include_15_45_10bpmerge.bed.gz

BASES10KB=${OUTDIR}/cov10kb.bed.gz
BASES100KB=${OUTDIR}/cov100kb.bed.gz

# count heterozygous SNPs that PASS, exclude indels, include only if in the targets BED

# 10kb window
bcftools view -m2 -M2 -v snps ${VCF} -f PASS | \
    bcftools filter -i 'GT="het"' | \
    bedtools intersect -a stdin -b ${TARGETS} -wa -header | \
    bedtools map -a ${BASES10KB} -b stdin -c 1 -o count | \
    bgzip >${OUTDIR}/hets10kb.bed.gz

# 100kb window
bcftools view -m2 -M2 -v snps ${VCF} -f PASS | \
    bcftools filter -i 'GT="het"' | \
    bedtools intersect -a stdin -b ${TARGETS} -wa -header | \
    bedtools map -a ${BASES100KB} -b stdin -c 1 -o count | \
    bgzip >${OUTDIR}/hets100kb.bed.gz

