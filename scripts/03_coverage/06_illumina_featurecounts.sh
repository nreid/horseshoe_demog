#!/bin/bash 
#SBATCH --job-name=featurecounts
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=general

hostname
date

# this script quantifies fragments mapping per sample in 1kb windows across the genome

# load software
module load subread/1.6.0
module load htslib/1.9
module load bedtools/2.29.0

# input, output directories, files

# input bams
INDIR=../../results/alignments/

# output file/directory
OUTDIR=../../results/coverage
mkdir -p $OUTDIR
OUTFILE=gmap_counts.txt

# create a bam list
LIST=$OUTDIR/bams.list
find $INDIR -name "SRR*bam" | grep -v "disc" | grep -v "split" | sort >$LIST

# create a 1kb nonoverlapping window SAF "annotation" file
BED=${OUTDIR}/1kbwin.bed
ANN=${OUTDIR}/1kbwin.saf
FAI=../../data/genome/genome.fa.fai

bedtools makewindows -g $FAI -w 5000 -s 5000 >$BED

echo -e "GeneID\tChr\tStart\tEnd\tStrand\n" >$ANN
awk '{OFS="\t"}{print NR,$1,$2+1,$3,"+"}' $BED >>$ANN


# run featureCounts
featureCounts \
-F SAF \
-Q 30 \
--primary \
-O \
-p \
-B \
-T 8 \
-a $ANN -o $OUTDIR/$OUTFILE $(cat $LIST | tr "\n" " ")

bgzip $OUTDIR/$OUTFILE

tabix -S 2 -s 2 -b 3 -e 4 $OUTDIR/${OUTFILE}.gz
