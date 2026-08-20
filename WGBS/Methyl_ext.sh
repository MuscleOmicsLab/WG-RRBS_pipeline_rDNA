#! /bin/bash 

# Performing the methylation extraction using bismark_methylation_extractor

echo 'start=' `date`

# If running on a cluster, load the required modules
# module load bismark/... 
# etc ...

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

BASE_BISMARK_DIR= # PATH TO OUTPUT BISMARK ALIGNMENT FILES
BASE_METHYL_EXTRACT_DIR= # PATH TO OUTPUT METHYLATION EXTRACTION FILES

GENOME_DIR= # PATH TO GENOME INDEXES

THREADS= # Number of threads to use for methylation extraction

# Obtaining the pe.bam for the paired-end alignment
INPUT_PE_ALIGNED=$BASE_BISMARK_DIR/$CONDITION/$SAMPLE/01
OUTPUT_METHYL_EXTRACT_DIR=$BASE_METHYL_EXTRACT_DIR/$CONDITION/$SAMPLE

echo "Processing directory: $INPUT_PE_ALIGNED"
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned

BAM_FILE_PE=$INPUT_PE_ALIGNED/*_pe.deduplicated.bam
bismark_methylation_extractor \
    -p \
    --parallel $THREADS \
    --bedGraph \
    --counts \
    --comprehensive \
    --report \
    --cytosine_report \
    --genome_folder $MUS_GENOME_DIR \
    -o $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned/ \
    $BAM_FILE_PE
