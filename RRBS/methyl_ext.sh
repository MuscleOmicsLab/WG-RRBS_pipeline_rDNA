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
INPUT_PE_ALIGNED= # Condition and sample specific input directory for paired-end alignment
UTPUT_METHYL_EXTRACT_DIR= # Condition and sample specific output directory for methylation extraction

echo "Processing directory: $INPUT_PE_ALIGNED"
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR
mkdir -p $OUTPUT_METHYL_EXTRACT_DIR/PE_aligned

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

echo "Methylation extraction completed for sample: $SAMPLE in condition: $CONDITION"