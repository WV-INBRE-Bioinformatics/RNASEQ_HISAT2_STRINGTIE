#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

# Change paths
export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"

# Change paths
DIR="$PROJECT_DIR/TRIM"

echo -e "\tTotal reads processed\tReads with adapters\tReads written (passing filters)\tTotal basepairs processed\tQuality-trimmed\tTotal written (filtered)"
for FILE in `cat $ALL_FILE_LIST`
do
	F=$FILE"_trimming_report.txt"

	echo -e -n "$FILE\t"

	grep "Total reads processed:\|Reads with adapters:\|Reads written (passing filters):\|Total basepairs processed:\|Quality-trimmed:\|Total written (filtered):"  $DIR/$F | sed 's/:/\t/g' |  sed 's/,//g' | awk 'BEGIN{FS="\t"}{printf("\t%s", $2);}'
	echo ""
done

# Sridhar A Malkaram (smalkaram@wvstateu.edu)
# Last modified on: 12/30/2017
