#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=20G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load MultiQC/1.9

INDIR=../../results/trimmedseqs/reports_gmap
OUTDIR=../../results/trimmedseqs/reports_gmap_multiqc

multiqc -f -o ${OUTDIR} ${INDIR}