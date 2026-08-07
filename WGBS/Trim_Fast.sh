#! /bin/bash

echo 'hostname $HOSTNAME'

# If running on a cluster, load the required modules
# module load bismark/... 
# etc ...

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

THREADS= # Number of threads to use for trimming

BASE_FAST_QC_dir= # PATH TO TRIMMED FASTQ FILES
TRIM_OUT_dir= # PATH TO OUTPUT TRIMMED FASTQ FILES

INPUT_FAST_QC_DIR=$BASE_FAST_QC_dir/$CONDITION/$SAMPLE
OUTPUT_FAST_QC_DIR=$TRIM_OUT_dir/$CONDITION/$SAMPLE

echo "Processing directory: $INPUT_FAST_QC_DIR"
mkdir -p $OUTPUT_FAST_QC_DIR

FAST_QC_PAIR_1= # Condition and sample specific input file for pair 1
FAST_QC_PAIR_2= # Condition and sample specific input file for pair 2

echo "Processing pair: $FAST_QC_PAIR_1 and $FAST_QC_PAIR_2"
trim_galore \
    --fastqc \
    --clip_R1 6 \
    --clip_R2 6 \
    --paired \
    --cores $THREADS \
    $FAST_QC_PAIR_1 \
    $FAST_QC_PAIR_2 \
    -o $OUTPUT_FAST_QC_DIR

echo "Finished trimming for sample: $SAMPLE in condition: $CONDITION"