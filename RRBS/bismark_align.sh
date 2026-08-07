#! /bin/bash 

echo 'hostname $HOSTNAME'

# If running on a cluster, load the required modules
# module load bismark/... 
# etc ...

PARENT_DIR=$1
CONDITION=$2
SAMPLE=$3

# Trimmed fastq files directory
BASE_TRIMMED_FAST_QC_DIR= # PATH TO TRIMMED FASTQ FILES
BISMARK_OUT_DIR= # PATH TO OUTPUT BISMARK ALIGNMENT FILES

GENOME_DIR= # PATH TO GENOME INDEXES

THREADS= # Number of threads to use for alignment

INPUT_TRIM_DIR= # Condition and sample specific input directory
OUTPUT_BISMARK_DIR= # Condition and sample specific output directory

mkdir -p $OUTPUT_BISMARK_DIR
mkdir -p $OUTPUT_BISMARK_DIR/01

TRIMMED_FAST_QC_PAIR_1= # Condition and sample specific input file for pair 1
TRIMMED_FAST_QC_PAIR_2= # Condition and sample specific input file for pair 2


echo "Processing directory: $INPUT_TRIM_DIR"

# -------------------------
# 1) ALIGN UNMAPPED TO MOUSE
# -------------------------
echo "=== Aligning reads to [species] ==="
bismark \
    --genome $MUS_GENOME_DIR \
    --temp_dir $OUTPUT_BISMARK_DIR \
    --parallel $THREADS \
    --unmapped \
    --non_directional \
    --score_min L,0,-0.2 \
    -1 $TRIMMED_FAST_QC_PAIR_1 \
    -2 $TRIMMED_FAST_QC_PAIR_2 \
    --output_dir $OUTPUT_BISMARK_DIR/01

echo "Bismark alignment completed for sample: $SAMPLE in condition: $CONDITION"