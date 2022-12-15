#!/bin/bash 
#SBATCH --job-name=clair3
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

source ~/.bashrc
conda activate clair3_0.1r12

# Set the number of CPUs to use
THREADS="12"

# input/output files, directories
BAM=../../results/alignments/rebasecall.bam

OUTDIR=../../results/variants_clair3
mkdir -p $OUTDIR

GENOME=../../data/genome/genome.fa

# run clair3 like this afterward
MODEL_NAME="r941_prom_sup_g5014"         # pulled from website. does not exactly match guppy version (6.3.8)

run_clair3.sh \
  --bam_fn=${BAM} \
  --ref_fn=${GENOME} \
  --threads=${THREADS} \
  --platform="ont" \
  --model_path="${CONDA_PREFIX}/bin/models/${MODEL_NAME}" \
  --include_all_ctgs \
  --output=${OUTDIR}