#!/bin/bash
#SBATCH --job-name=getdata
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=gpu
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=your.email@uconn.edu
#SBATCH --mem=100G
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

# load software
module load guppy/6.3.8-GPU


# directories, files
# promethion run: 29May2019_HsC-male-blood_PAD59173_PR002_LSK109
RAWDIR=/archive/projects/EBP/roneill/reads/nanopore/promethion/limulus/29May2019_HsC-male-blood_PAD59173_PR002_LSK109/29MAY2019_HsC-male-blood_PAD59173_PRO002_LSK109-fast5_pass/fast5_pass

OUTDIR=../../data/rebasecalled_reads
    mkdir -p ${OUTDIR}

# run guppy

guppy-basecaller  \
    --input_path ${RAWDIR} \
    --save_path ${OUTDIR} \
    --config dna_r9.4.1_450bps_sup.cfg
