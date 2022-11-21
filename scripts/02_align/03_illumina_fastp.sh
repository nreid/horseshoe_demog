#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo `hostname`
date

#################################################################
# Trimming/QC of reads using fastp
#################################################################
module load fastp/0.23.2

# set input/output directory variables
INDIR=../../data/reads
OUTDIR=../../results/trimmed_illumina
	mkdir -p ${OUTDIR}
REPORTDIR=../../results/trimmed_illumina/fastp_reports
mkdir -p ${REPORTDIR}

# run fastp on accession SRR6852085
fastp \
	--in1 $INDIR/SRR4181534_1.fastq \
	--in2 $INDIR/SRR4181534_2.fastq \
	--out1 $OUTDIR/SRR4181534_trim_1.fastq \
	--out2 $OUTDIR/SRR4181534_trim_2.fastq \
	--json $REPORTDIR/SRR4181534_fastp.json \
	--html $REPORTDIR/SRR4181534_fastp.html

