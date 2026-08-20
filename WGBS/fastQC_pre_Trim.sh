#! /bin/bash 

echo "hostname = $HOSTNAME"

#Load modules

# Inputting the parent directory, condition, and sample name as command line arguments
PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

# Base directories
BASE_FASTQ_DIR= # PATH TO FASTQ FILES
BASE_FAST_QC_OUTPUT_DIR= # PATH TO OUTPUT FASTQC FILES

INPUT_FAST_QC_DIR= # Condition and sample specific input directory
OUTPUT_FAST_QC_DIR= # Condition and sample specific output directory

echo "Processing directory: $INPUT_FAST_QC_DIR"
mkdir -p $OUTPUT_FAST_QC_DIR

fastqc \
    --threads 16 \
    $INPUT_FAST_QC_DIR/${SAMPLE}_1.fastq.gz \
    $INPUT_FAST_QC_DIR/${SAMPLE}_2.fastq.gz \
    -o $OUTPUT_FAST_QC_DIR

echo "FastQC completed for sample: $SAMPLE in condition: $CONDITION"
