#! /bin/bash 

# Performing the methylation extraction using bismark_methylation_extractor

echo 'start=' `date`

# If running on a cluster, load the required modules
# module load bismark/... 
# etc ...

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

BASE_BISMARK_DIR= # Path to aligned files. 
BASE_METHYL_EXTRACT_DIR= # Path to output files.

GENOME_DIR= # PATH TO GENOME INDEXES

THREADS= # Number of threads to use for the methylation extraction

# Obtaining the pe.bam for the paired-end alignment
INPUT_PE_ALIGNED=$BASE_BISMARK_DIR/$CONDITION/$SAMPLE/01
INPUT_SE_R1_ALIGNED=$BASE_BISMARK_DIR/$CONDITION/$SAMPLE/02_trick_R1
INPUT_SE_R2_ALIGNED=$BASE_BISMARK_DIR/$CONDITION/$SAMPLE/02_trick_R2
OUTPUT_METHYL_EXTRACT_DIR= # Condition and sample specific output directory for methylation extraction

echo "Processing directory: $INPUT_PE_ALIGNED, $INPUT_SE_R1_ALIGNED, $INPUT_SE_R2_ALIGNED"

# making subdirectories for the methylation extraction output
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/SE_R1_aligned
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/SE_R2_aligned
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/PE_and_SE_merged

BAM_FILE_PE=$INPUT_PE_ALIGNED/*_pe.bam
bismark_methylation_extractor \
    -p \
    --gzip \
    --parallel $THREADS \
    --bedGraph \
    --counts \
    --comprehensive \
    --ignore_r2 2 \
    --ignore_3prime_r2 2 \
    --ignore_3prime 5 \
    --ignore 5 \
    --report \
    --cytosine_report \
    --genome_folder $RAT_GENOME_DIR \
    -o $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned/ \
    $BAM_FILE_PE


# Methyl extraction for the single end
BAM_FILE_SE_R1=$INPUT_SE_R1_ALIGNED/*.bam
bismark_methylation_extractor \
    -s \
    --gzip \
    --parallel $THREADS \
    --bedGraph \
    --counts \
    --comprehensive \
    --ignore_3prime 5 \
    --ignore 5 \
    --report \
    --cytosine_report \
    --genome_folder $RAT_GENOME_DIR \
    -o $OUTPUT_METHYL_EXTRACT_DIR/SE_R1_aligned/ \
    $BAM_FILE_SE_R1

BAM_FILE_SE_R2=$INPUT_SE_R2_ALIGNED/*.bam
bismark_methylation_extractor \
    -s \
    --gzip \
    --parallel $THREADS \
    --bedGraph \
    --counts \
    --comprehensive \
    --ignore_3prime 5 \
    --ignore 5 \
    --report \
    --cytosine_report \
    --genome_folder $RAT_GENOME_DIR \
    -o $OUTPUT_METHYL_EXTRACT_DIR/SE_R2_aligned/ \
    $BAM_FILE_SE_R2

# Using bismark2bedGraph to merge the single-end and paired-end files into a comprehensive coverage file
bismark2bedGraph \
    --dir $OUTPUT_METHYL_EXTRACT_DIR/PE_and_SE_merged/ \
    -o PE_and_SE_merged.bedGraph.gz \
    $OUTPUT_METHYL_EXTRACT_DIR/SE_R1_aligned/CpG* \
    $OUTPUT_METHYL_EXTRACT_DIR/SE_R2_aligned/CpG* \
    $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned/CpG*
