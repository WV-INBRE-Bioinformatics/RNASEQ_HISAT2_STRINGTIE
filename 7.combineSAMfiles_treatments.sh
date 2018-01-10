#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"

# Compenseate PATH variable in lieu of this module
module load bio/processing/picard/2.9.2

for TR in KO_20W_AL KO_20W_CR KO_80W_AL KO_80W_CR OE_20W_AL OE_20W_CR OE_80W_AL OE_80W_CR WT_20W_AL WT_20W_CR WT_80W_AL WT_80W_CR
do

	# Chage path as necessary
	INPUT_SAM_FILES=`find /home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2 -name "*.sam" | grep "$TR" | awk '{printf("I=%s ", $1);}'`
	OUTPUT_SAM_FILE="O=$TR.Merged.bam"
	picard MergeSamFiles $INPUT_SAM_FILES $OUTPUT_SAM_FILE
done

# Sridhar A Malkaram (smalkaram@wvstateu.edu)
# Last modified on: 12/30/2017
