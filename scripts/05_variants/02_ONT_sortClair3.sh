#!/bin/bash 
#SBATCH --job-name=sortclair3
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=50G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load bedtools/2.29.0
module load htslib/1.12

OUTDIR=../../results/variants_clair3/
VCF=${OUTDIR}/merge_output.vcf.gz
FAI=../../data/genome/genome.fa.fai

bedtools sort -header -faidx ${FAI} -i ${VCF} | bgzip >${OUTDIR}/merge_sorted.vcf.gz
tabix -p vcf ${OUTDIR}/merge_sorted.vcf.gz