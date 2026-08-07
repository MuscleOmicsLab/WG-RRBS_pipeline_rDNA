#! /bin/bash 

echo 'hostname $HOSTNAME'

# If running on a cluster, load the required modules
# module load bismark/... 
# etc ...

# Extracting the arguments
PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

THREADS= # Number of threads to use for deduplication

# Trimmed fastq files directory
BASE_ALIGNED_DIR= # PATH TO OUTPUT BISMARK ALIGNMENT FILES
DEDUP_OUT_DIR= # PATH TO OUTPUT DEDUPLICATED FILES
OUTPUT_BISMARK_REPORT_DIR= # PATH TO OUTPUT BISMART REPORT FILES

INPUT_ALIGNED_DIR=$BASE_ALIGNED_DIR/$CONDITION/$SAMPLE/01
INPUT_ALIGNED_DIR_R1=$BASE_ALIGNED_DIR/$CONDITION/$SAMPLE/02_trick_R1
INPUT_ALIGNED_DIR_R2=$BASE_ALIGNED_DIR/$CONDITION/$SAMPLE/02_trick_R2
OUTPUT_DEDUP_SAMPLE_DIR= # Condition and sample specific output directory for deduplicated files
OUTPUT_BISMARK_REPORT_SAMPLE_DIR= # Condition and sample specific output directory for bismark report files

mkdir -p $OUTPUT_DEDUP_SAMPLE_DIR
mkdir -p $OUTPUT_DEDUP_SAMPLE_DIR/01
mkdir -p $OUTPUT_DEDUP_SAMPLE_DIR/02_trick_R1
mkdir -p $OUTPUT_DEDUP_SAMPLE_DIR/02_trick_R2

INPUT_BAM_01= # Condition and sample specific input directory for paired-end alignment
INPUT_BAM_R1= # Condition and sample specific input directory for single-end alignment R1
INPUT_BAM_R2= # Condition and sample specific input directory for single-end alignment R2

echo "Processing directory: $INPUT_ALIGNED_DIR"

# -------------------------ls
# Deduplicate
# -------------------------
echo "=== Deduplicating the alignment ==="
deduplicate_bismark \
    -p \
    $INPUT_BAM_01 \
    --output_dir $OUTPUT_DEDUP_SAMPLE_DIR/01

deduplicate_bismark \
    -s \
    $INPUT_BAM_R1 \
    --output_dir $OUTPUT_DEDUP_SAMPLE_DIR/02_trick_R1

deduplicate_bismark \
    -s \
    $INPUT_BAM_R2 \
    --output_dir $OUTPUT_DEDUP_SAMPLE_DIR/02_trick_R2

bismark2report \
    --alignment_report $INPUT_ALIGNED_DIR/01/_PE_report.txt \
    --deduplicated_bam $OUTPUT_DEDUP_SAMPLE_DIR/01/_pe.deduplicated.bam \
    --output_dir $OUTPUT_BISMARK_REPORT_SAMPLE_DIR
