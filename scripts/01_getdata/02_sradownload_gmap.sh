#!/bin/bash
#SBATCH --job-name=sradownload_gmap
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=your.email@uconn.edu
#SBATCH --mem=10G
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

module load parallel/20180122
module load sratoolkit/3.0.1

# files, directories
OUTDIR=../../data/reads_gmap
    mkdir -p ${OUTDIR}

ACCLIST=../../metadata/metadata.csv

tail -n +2 $ACCLIST | cut -f 1 -d "," | parallel -j 2 fasterq-dump --outdir ${OUTDIR} --temp ${OUTDIR} {}

# compress the files 
ls ${OUTDIR}/*fastq | parallel -j 12 gzip