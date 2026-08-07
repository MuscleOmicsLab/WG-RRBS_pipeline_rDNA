#! /bin/bash 

echo 'hostname $HOSTNAME'

module load fastqc/0.11.9-gcc-13.2.0

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

BASE_TRIM_DIR= # PATH TO TRIMMED FILES
OUTPUT_BASE_TRIM_DIR= # PATH TO OUTPUT FASTQC FILES

INPUT_TRIM_DIR= # Condition and sample specific input directory
OUTPUT_TRIM_DIR= # Condition and sample specific output directory

echo "Processing directory: $INPUT_TRIM_DIR"
mkdir -p $OUTPUT_TRIM_DIR

fastqc \
    --threads 16 \
    $INPUT_TRIM_DIR/${SAMPLE}_1_val_1.fq.gz \
    $INPUT_TRIM_DIR/${SAMPLE}_2_val_2.fq.gz \
    -o $OUTPUT_TRIM_DIR

echo "FastQC completed for sample: $SAMPLE in condition: $CONDITION"