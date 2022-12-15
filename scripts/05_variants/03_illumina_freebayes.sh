#!/bin/bash
#SBATCH --job-name=freebayes_nfpipe
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 5
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=15G
#SBATCH --mail-user=
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load nextflow/22.04.0

OUTDIR=../../results/illumina_variants
    mkdir -p ${OUTDIR}

cp local.config ${OUTDIR}   

cd ${OUTDIR}

nextflow run \
    /home/FCAM/nreid/fb_parallel/main.nf \
    -c local.config \
    -resume 