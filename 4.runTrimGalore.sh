#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files


module load bio/processing/Fastqc/0.11.5
module load pkg/perl5/5.22.1
module load pkg/anaconda2/4.3.1
module load bio/processing/trim_galore/0.4.4

IN="$DATA_DIR"
# Change the path
OUT="/home/smalkaram/Projects/alwayMRNA20170516143625/TRIM"
Fadapter=" -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
Radapter=" -a2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"

#Encoding        Sanger / Illumina 1.9
PHRED=" --phred33 "
#Sequence length 51

MINLEN=16

#CUTOPTIONS=" -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -a "A{5}"  -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 -m 16 --max-n 3 --pair-filter=both --too-short-output too_short.fastq  "
TRIMGALOREOPTIONS=" $PHRED -q 20  $Fadapter $Radapter --gzip --length $MINLEN --paired --trim1 --retain_unpaired "



for FILE in `cat $ALL_FILE_LIST`
do
	# Ignore the 2nd read, as these are taken care of
	if [[ $FILE =~ _2.fastq.gz ]]; then
		continue;
	fi

	BASE=`echo $FILE | sed 's/_..fastq.gz//'`

	#echo "$OUT/$BASE"
	#mkdir -p $OUT/$BASE

	FORWARD=$DATA_DIR/$BASE"_1.fastq.gz"
	REVERSE=$DATA_DIR/$BASE"_2.fastq.gz"

	echo $BASE
	echo "trim_galore -o $OUT $TRIMGALOREOPTIONS $FORWARD $REVERSE"  | qsub -N $BASE -q batch -l nodes=1:ppn=2 -V -d $OUT

done

# Sridhar A Malkaram (smalkaram@wvstateu.edu)
# Last modified on: 12/30/2017
