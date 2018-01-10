#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"

# Change path as necessary
INDIR="$PROJECT_DIR/TRIM"
# Compensate PATH variable in lieu of these modules
module load bio/alignment/hisat2/2.0.5
module load bio/alignment/bowtie2/2.3.2
module load bio/assembly/stringtie/1.3.3b
THREADS=" -p 4 "

# Change these paths as necessary
REFERENCE=" -G /home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2/STRINGTIE/STRINGTIE_MERGE/Merged.gtf"
BAM_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2/STRINGTIE"

for FILE in KO_20W_AL KO_20W_CR KO_80W_AL KO_80W_CR OE_20W_AL OE_20W_CR OE_80W_AL OE_80W_CR WT_20W_AL WT_20W_CR WT_80W_AL WT_80W_CR

do
	for REP in R1 R2 R3 R4 
	do
       		BASE=$FILE.$REP
		# Change this path
		OUT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2/STRINGTIE/STRINGTIE_MERGE/STRINGTIE_MAIN2/$BASE"
		mkdir -p $OUT_DIR

		BAM=$BAM_DIR/$BASE.Merged.bam

		if [ ! -f $BAM ]; then
			echo "$FILE : no DATA"
			continue
		fi
		GTF=" -o $OUT_DIR/BASE.gtf"
		ABUNDANCES=" -A $OUT_DIR/$BASE.gene_abund.tab"
		COVREFS=" -C $OUT_DIR/$BASE.cov_refs.gtf"
		#CTABFILES=" -B "
		#CTABFILES=""
		CTABPATH=" -b $OUT_DIR "
		NONOVEL=" -e "

		# Submit the job
		echo "stringtie $BAM $GTF $REFERENCE $ABUNDANCES $COVREFS $CTABFILES $CTABPATH $THREADS $NONOVEL" | qsub -V -N $BASE -l nodes=1:ppn=4 -q long
	done
done
# Sridhar A Malkaram (smalkaram@wvstateu.edu)
# Last modified on: 12/30/2017
