#! /bin/sh

# Change the paths as necessary
# DATA_DIR is the location of raw fastq files
# PROJECT_DIR is the main directory for this analysis
# ALL_FILE_LIST is the list of renamed sample fastq files

export PROJECT_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625"
export DATA_DIR="/home/smalkaram/Projects/alwayMRNA20170516143625/raw_data/file_links"
export ALL_FILE_LIST="/home/smalkaram/Projects/alwayMRNA20170516143625/ALL_FILE_LIST"

function SUBMIT_JOB()
{

    local BASE=$1
    local RG=$2
    local F=$3
    local R=$4
    local Fs=$5
    local Rs=$6
    local NODE=$7
    local INDEX=$8
    INDEX=" -x $INDEX "

    # input
    local FORWARD=" -1 $F "
    local REVERSE=" -2 $R "
    local UNPAIRED=" -U $Fs,$Rs "
    #SRA=" --sra-acc "
    local TYPE=" -q "
    local QUAL=" --phred33 "

    # alignment

    # scoring

    # reporting

    # sam
    local READGROUP=" --rg-id $BASE "
    for GROUP in `echo $RG | sed 's/___/ /g'`
    do
        READGROUP="$READGROUP --rg $GROUP "
    done

    #performance
    local THREADS=" -p 3 "
    #MEMORYMAP=" --mm "
    local MEMORYMAP=""

    # other
    #SEED=" --seed 9876543210"
    local SEED=""

    local OUT1="$PROJECT_DIR/TRIM/HISAT2/$BASE/paired"
    local OUT2="$PROJECT_DIR/TRIM/HISAT2/$BASE/single"

    # make the result directories
    mkdir -p $OUT1 
    mkdir -p $OUT2

    # spliced options
    #KNOWN_JUNCS=" --known-splicesite-infile "    #splice sites are included in the index, so not needed

    local CUFFLINKS=" --dta-cufflinks "

    # PAIRED-----------------------------------------------------------------------------------------------------
    local SAM=" -S $OUT1/$BASE.paired.sam"
    local NOVEL=" --novel-splicesite-outfile $OUT1/$BASE.paired.sjdb "
    local METRICS=" --met-file $OUT1/$BASE.paired.metrics --met 60"


cat<<_EOF_ > $BASE.p.sh 
#!/bin/bash
#PBS -N p.$BASE
#PBS -V
#PBS -o $OUT1/$BASE.p.stdout
#PBS -e $OUT1/$BASE.p.stderr
#PBS -l nodes=1:ppn=3
#PBS -q long
    module load bio/alignment/hisat2/2.0.5
    module load bio/alignment/bowtie2/2.3.2
    cd $OUT1
    /data/bio/alignment/hisat2/2.0.5/hisat2 $TYPE $QUAL $NOVEL $CUFFLINKS $METRICS $READGROUP $THREADS $MEMORYMAP $SEED $INDEX $FORWARD $REVERSE $SAM
_EOF_
	qsub -d $OUT1 -N p.$BASE $BASE.p.sh

    # SINGLE-----------------------------------------------------------------------------------------------------
    SAM=" -S $OUT2/$BASE.single.sam"
    NOVEL=" --novel-splicesite-outfile $OUT2/$BASE.single.sjdb "
    METRICS=" --met-file $OUT2/$BASE.single.metrics --met 60"

cat<<_EOF_ > $BASE.s.sh 
#!/bin/bash
#PBS -N s.$BASE
#PBS -V
#PBS -o $OUT2/$BASE.s.stdout
#PBS -e $OUT2/$BASE.s.stderr
#PBS -l nodes=1:ppn=3
#PBS -q long
    module load bio/alignment/hisat2/2.0.5
    module load bio/alignment/bowtie2/2.3.2
    cd $OUT2
    /data/bio/alignment/hisat2/2.0.5/hisat2 $TYPE $QUAL $NOVEL $CUFFLINKS $METRICS $READGROUP $THREADS $MEMORYMAP $SEED $INDEX $UNPAIRED $SAM
_EOF_
	qsub -d $OUT2 -N s.$BASE $BASE.s.sh

}


# load this project

# Change path as necessary
INDIR="$PROJECT_DIR/TRIM"

# Compensate PATH variable in lieu of these modules
module load bio/alignment/hisat2/2.0.5
module load bio/alignment/bowtie2/2.3.2

# Change path
INDEX_BASE="/data/db/Hisat2Indexes/GenCode_GRCm38p5/genCodeGRCm38p5"

COUNT=1

for FILE in `cat $ALL_FILE_LIST`
do
        # Ignore the 2nd read, as these are taken care of internally
        if [[ $FILE =~ _2.fastq.gz ]]; then
                continue;
        fi

        BASE=`echo $FILE | sed 's/_1.fastq.gz//'`

	# Change paths as necessary
        F=$INDIR/$BASE"_1_val_1.fq.gz"
        Fs=$INDIR/$BASE"_1_unpaired_1.fq.gz"
        R=$INDIR/$BASE"_2_val_2.fq.gz"
        Rs=$INDIR/$BASE"_2_unpaired_2.fq.gz"

    # Get the read group from this file
    # Change paths as necessary
    RG=`cat  $PROJECT_DIR/getRGs.txt | grep "$BASE" | cut -f 2- | cut -d ' ' -f 3- | sed 's/\ /___/g'`

    # Get the node to be run on from this file. * qsub submission is getting killed for unknown reason
    #NODE=`cat /home/smalkaram/Projects/alwayMRNA20170516143625/TRIM/HISAT2/NODE_LIST | awk -v T=$COUNT '{if(NR==T) printf("%s", $0);}'`
    NODE="none"
    #echo $NODE

    # Submit the job
    SUBMIT_JOB $BASE $RG $F $R $Fs $Rs $NODE $INDEX_BASE
    
    COUNT=`expr $COUNT + 1`
done

