#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"


# Compensate PATH variable in lieu of this module
module load bio/assembly/stringtie/1.3.3b

# Change path as necessary
REFERENCE=" -G /data/db/GenCode/GRCm38p5/gencode.vM14.primary_assembly.annotation.gtf"
THREADS=" -p 12 "

OUT=" -o Merged.gtf"

# Submit the job
# Change paths to all the files as necessary
stringtie --merge $OUT $REFERENCE $THREADS ../KO_20W_AL.Merged.gtf ../KO_20W_CR.Merged.gtf ../KO_80W_AL.Merged.gtf ../KO_80W_CR.Merged.gtf ../OE_20W_AL.Merged.gtf ../OE_20W_CR.Merged.gtf ../OE_80W_AL.Merged.gtf ../OE_80W_CR.Merged.gtf ../WT_20W_AL.Merged.gtf ../WT_20W_CR.Merged.gtf ../WT_80W_AL.Merged.gtf ../WT_80W_CR.Merged.gtf
# Sridhar A Malkaram (smalkaram@wvstateu.edu)
# Last modified on: 12/30/2017
