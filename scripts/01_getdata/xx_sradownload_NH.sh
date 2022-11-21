#!/bin/bash
#SBATCH --job-name=sradownload
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=your.email@uconn.edu
#SBATCH --mem=10G
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

module load sratoolkit/2.11.3

READDIR=../../data/reads/

# this script grabs illumina data from a prior limulus genome assembly study. about 30x coverage of PE illumina data
# WGS of Limulus polyphemus: skeletal leg muscle
    # BioProject: PRJNA340394
     # https://www.ncbi.nlm.nih.gov/bioproject/PRJNA340394
    # SRA RUN ID: SRR4181534
        # 100bp PE reads
    # published here: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5317147/
        # individual sampled from
            # Great Bay Estuary in Durham, NH (43°05′30′′N and 70°51′55′′W)
        # no sex noted

# THIS DATA HAD TRUNCATED QUALITY SCORES AND WAS NOT USEFUL

cd ${READDIR}

fasterq-dump SRR4181534