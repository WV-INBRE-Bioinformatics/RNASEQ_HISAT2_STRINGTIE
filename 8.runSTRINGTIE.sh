#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"

# Compensate path variable in lieu of this module
module load bio/assembly/stringtie/1.3.3b

# Change this path as necessary
REFERENCE=" -G /data/db/GenCode/GRCm38p5/gencode.vM14.primary_assembly.annotation.gtf"
THREADS=" -p 12 "

for BASE in KO_20W_AL KO_20W_CR KO_80W_AL KO_80W_CR OE_20W_AL OE_20W_CR OE_80W_AL OE_80W_CR WT_20W_AL WT_20W_CR WT_80W_AL WT_80W_CR

do
	BAM=$BASE.Merged.bam
	OUT=" -o $BASE.Merged.gtf"

	# Submit the job
	# Change this path as necessary
	echo "stringtie $BAM $OUT $REFERENCE $THREADS" | qsub -V -N $BASE -l nodes=1:ppn=12 -q long -d /home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2/STRINGTIE
done
