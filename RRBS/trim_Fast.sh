#! /bin/bash

echo 'hostname $HOSTNAME'

module load trimgalore/0.6.6-gcc-13.2.0-python-3.11.6

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

SLURM_CPUS_PER_TASK= # Insert the number of CPUs allocated for the job

BASE_FAST_QC_dir= # PATH TO FASTQ FILES
TRIM_OUT_dir= # PATH TO OUTPUT TRIMMED FILES

INPUT_FAST_QC_DIR= # Condition and sample specific input directory
OUTPUT_FAST_QC_DIR= # Condition and sample specific output directory

echo "Processing directory: $INPUT_FAST_QC_DIR"
mkdir -p $OUTPUT_FAST_QC_DIR

FAST_QC_PAIR_1= # Condition and sample specific input file for pair 1  
FAST_QC_PAIR_2= # Condition and sample specific input file for pair 2

echo "Processing pair: $FAST_QC_PAIR_1 and $FAST_QC_PAIR_2"
trim_galore \
    --rrbs \
    --non_directional \
    --paired \
    --cores $SLURM_CPUS_PER_TASK \
    $FAST_QC_PAIR_1 \
    $FAST_QC_PAIR_2 \
    -o $OUTPUT_FAST_QC_DIR

echo "Trim Galore completed for sample: $SAMPLE in condition: $CONDITION"
