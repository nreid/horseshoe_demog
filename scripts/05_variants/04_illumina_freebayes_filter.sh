#!/bin/bash
#SBATCH --job-name=freebayes_filter
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=5G
#SBATCH --mail-user=
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load bcftools/1.16
module load htslib/1.16
module load vcftools/0.1.16
module load vt/0.57721
module load vcflib/1.0.0-rc1


# input/output files/directories
VCF=../../results/illumina_variants/results/vcf_raw/freebayes.vcf.gz
OUTDIR=../../results/illumina_variants/

OUTVCF1=${OUTDIR}/filter1.vcf.gz
TARGETS=../../results/coverage/illumina_include_25_80_10bpmerge.bed.gz

# filter
bcftools filter -R ${TARGETS} -e "QUAL < 30 || INFO/AF < 0.05 || INFO/DP > 100 || INFO/DP < 10" $VCF | \
    bgzip >${OUTVCF1}
tabix -p vcf ${OUTVCF1}

# summarize
vt peek ${VCF} >${OUTDIR}/vtpeek_unfiltered.txt
vt peek ${OUTVCF1} >${OUTDIR}/vtpeek_filtered1.txt

# reformat to extract genotypes
zcat ${OUTVCF1} | vcfallelicprimitives  | \
    bcftools view -m 2 -M 2 - | \
    bcftools query -H -f '%CHROM\t%POS\t[\t%GT]\n' - | \
    bgzip >$OUTDIR/biallelic_genos.tsv.gz
