#!/bin/bash
#SBATCH --job-name=getdata
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

module load samtools/1.16.1

# data have been produced by R. O'Neill Lab. Symlinking into this project. 

GENOMEDIR=../../data/genome
    mkdir -p ${GENOMEDIR}
ANNOTATIONDIR=../../data/annotation
    mkdir -p ${ANNOTATIONDIR}
READSDIR=../../data/reads
    mkdir -p ${READSDIR}

# symlink genome
ln -s /core/projects/EBP/Oneill/limulus_combined_promethion_minion_data_assembly/hic/hic_clean_reads_purge_dups_medaka_limulus_flye_assembly_pro_superbasecall_musc_blood_minion_rmv_contam/3ddna_post/26_chr_length_hic_clean_reads_purge_dups_medaka_limulus_flye_assembly_pro_superbasecall_musc_blood_minion_rmv_contam.fasta ${GENOMEDIR}/genome.fa
samtools faidx ${GENOMEDIR}/genome.fa
 
# symlink annotation(s)
ln -s /core/projects/EBP/Oneill/limulus_combined_promethion_minion_data_assembly/annotation/gfacs/gfacs_entap_filter_ltrs/gfacs_o/out.gff3 ${ANNOTATIONDIR}/anno.gff3
ln -s /core/projects/EBP/Oneill/limulus_combined_promethion_minion_data_assembly/annotation/gfacs/gfacs_entap_filter_ltrs/gfacs_o/out.gtf ${ANNOTATIONDIR}/anno.gtf

# symlink QC'ed reads
    # these reads have already been screened for contaminant sequences
# minion
ln -s /archive/labs/wegrzyn/genomes/horseshoe_crab/reads/clean_reads/minion/rmv_contam_24APR19_HsC-circul_combined_reads.fq \
    ${READSDIR}/rmv_contam_24APR19_HsC-circul_combined_reads.fq
ln -s /archive/labs/wegrzyn/genomes/horseshoe_crab/reads/clean_reads/minion/rmv_contam_24APR19_HsC-SPRIselect_combined_reads.fq \
    ${READSDIR}/rmv_contam_24APR19_HsC-SPRIselect_combined_reads.fq
ln -s /archive/labs/wegrzyn/genomes/horseshoe_crab/reads/clean_reads/minion/rmv_contam_30APR19_HsC-circul-full_combined_reads.fq \
    ${READSDIR}/rmv_contam_30APR19_HsC-circul-full_combined_reads.fq

# promethion
ln -s /archive/labs/wegrzyn/genomes/horseshoe_crab/reads/clean_reads/promethion/rerun_rmv_contam_29MAY2019_HsC-male-blood_PAD59173_PRO002_LSK109-reads-pass.fastq \
    ${READSDIR}/rerun_rmv_contam_29MAY2019_HsC-male-blood_PAD59173_PRO002_LSK109-reads-pass.fastq
ln -s /archive/labs/wegrzyn/genomes/horseshoe_crab/reads/clean_reads/promethion/rmv_contam_promethion_limulus_muscle_2019NOV13_Super_Accurate_18NOV21.fastq \
    ${READSDIR}/rmv_contam_promethion_limulus_muscle_2019NOV13_Super_Accurate_18NOV21.fastq