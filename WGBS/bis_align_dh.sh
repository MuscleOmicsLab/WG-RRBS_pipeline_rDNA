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

GENOME_DIR= # PATH TO MOUSE GENOME INDEXES

THREADS= # Number of threads to use for alignment

INPUT_TRIM_DIR=$BASE_TRIMMED_FAST_QC_DIR/$CONDITION/$SAMPLE
OUTPUT_BISMARK_DIR=$BISMARK_OUT_DIR/$CONDITION/$SAMPLE

mkdir -p $OUTPUT_BISMARK_DIR
mkdir -p $OUTPUT_BISMARK_DIR/01
mkdir -p $OUTPUT_BISMARK_DIR/02_trick_R1
mkdir -p $OUTPUT_BISMARK_DIR/02_trick_R2

TRIMMED_FAST_QC_PAIR_1=$INPUT_TRIM_DIR/*_1.fq.gz
TRIMMED_FAST_QC_PAIR_2=$INPUT_TRIM_DIR/*_2.fq.gz


echo "Processing directory: $INPUT_TRIM_DIR"

# -------------------------
# 1) ALIGN UNMAPPED TO MOUSE
# -------------------------
echo "=== [1/3] Aligning Lambda-unmapped reads to [species] ==="
bismark \
    --genome $MUS_GENOME_DIR \
    --temp_dir $OUTPUT_BISMARK_DIR \
    --parallel $THREADS \
    --unmapped \
    --pbat \
    -1 $TRIMMED_FAST_QC_PAIR_1 \
    -2 $TRIMMED_FAST_QC_PAIR_2 \
    --output_dir $OUTPUT_BISMARK_DIR/01

# Performming the dirty Harry trick
# Assigning the unaligned files to variables based on the expected Bismark output names
UNMAPPED_1=$OUTPUT_BISMARK_DIR/01/*_unmapped_reads_1.fq.gz
UNMAPPED_2=$OUTPUT_BISMARK_DIR/01/*_unmapped_reads_2.fq.gz

# UNMAPPED_1 is algined as a single-end file in bismark
bismark \
    --genome $MUS_GENOME_DIR \
    --temp_dir $OUTPUT_BISMARK_DIR \
    --parallel $THREADS \
    --pbat \
    $UNMAPPED_1 \
    --output_dir $OUTPUT_BISMARK_DIR/02_trick_R1

# UNMAPPED_2 is algined as a single-end file in bismark
bismark \
    --genome $MUS_GENOME_DIR \
    --temp_dir $OUTPUT_BISMARK_DIR \
    --parallel $THREADS \
    --pbat \
    $UNMAPPED_2 \
    --output_dir $OUTPUT_BISMARK_DIR/02_trick_R2

echo "Bismark alignment completed for sample: $SAMPLE in condition: $CONDITION"