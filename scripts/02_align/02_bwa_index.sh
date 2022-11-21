#!/bin/bash
#SBATCH --job-name=bwa_index
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

hostname
date

# load required software
module load bwa/0.7.17

GENOME=../../data/genome/genome.fa
INDEX=../../data/genome/limulus_index

bwa index -p ${INDEX} ${GENOME}