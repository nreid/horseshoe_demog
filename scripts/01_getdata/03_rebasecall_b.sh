#!/bin/bash
#SBATCH --job-name=rebasecall_blood
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=gpu
#SBATCH --qos=general
#SBATCH -x xanadu-[84-85]
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
# promethion run: 2019NOV13_Limulus_malemuscle_PAE06115_LSK109
RAWDIR=/scratch/nreid/muscle/fast5_pass/

OUTDIR=../../data/rebasecalled_reads/muscle
    mkdir -p ${OUTDIR}

# run guppy

guppy_basecaller  \
    --input_path ${RAWDIR} \
    --save_path ${OUTDIR} \
    --config dna_r9.4.1_450bps_sup.cfg \
    -x "cuda:0"

# alternate way of supplying fast5 files
# ls ${RAWDIR}/*fast5 | guppy_basecaller  \
#     --save_path ${OUTDIR} \
#     --config dna_r9.4.1_450bps_sup.cfg \
#     -x "cuda:0"
