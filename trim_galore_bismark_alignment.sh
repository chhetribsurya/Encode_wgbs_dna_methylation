#!/bin/bash

### Instructions: This script executes bismark and trim galore for each single-end fastqs.

##SOURCE_DIR="/opt/HAIB/myerslab/etc"
#SOURCE_DIR="/gpfs/gpfs2/software/HAIB/myerslab/etc"
#
#### Mandatory sourcing of bashrc for necessary environment variables. ###
#if [ -e $SOURCE_DIR/bashrc ]; then
#    . $SOURCE_DIR/bashrc
#else echo "[fatal] - Could not find myerslab bashrc file. Exiting"; exit 1; fi
#
#### Mandatory sourcing of functions to get helper functions (like call_cmd). ###
#if [ -e $SOURCE_DIR/functions ]; then
#    . $SOURCE_DIR/functions
#else echo "[fatal] - Could not find functions file. Exiting"; exit 1; fi
#
#### Verify we are not running on the head node. ###
#if [ -z "$LSB_JOBID" ]; then log_msg fatal "Please run on a compute node. Exiting"; exit 1; fi

### Python 2.7 used for cutadapt:
#source ~/python/anaconda_python_version2.sh

### Variables passed from the previous script call_trim_galore_bismark_alignment.sh retained:
INPUT_FILE_R1=$1
INPUT_FILE_R2=$2
OUTPUT_DIR=$3
LAMBDA_OUTPUT_DIR=$5

### Set the temporary dir:
#TEMP_DIR=$(get_temp_dir)
TEMP_DIR=$4

### Run trim galore on each splitted paired-end fastqs with 18 million reads, and clip 4-bp from each end to get rid of any poor read quality bias: 
$TRIMGALORE_PATH/trim_galore -o $TEMP_DIR --dont_gzip --clip_R1 3 --clip_R2 3 --three_prime_clip_R1 3 --three_prime_clip_R2 3 --paired $INPUT_FILE_R1 $INPUT_FILE_R2

#echo "Here are the trimmed files:"
#ls -l $TEMP_DIR

### Set names to trimmed fastqs for read_1 and read_2:
TRIMMED_R1=$TEMP_DIR/$(basename $INPUT_FILE_R1 .fastq.gz)_val_1.fq  ### read_1
TRIMMED_R2=$TEMP_DIR/$(basename $INPUT_FILE_R2 .fastq.gz)_val_2.fq  ### read_2

echo "here are the trimmmed files that would be forwarded for the analysis: $TRIMMED_R1 & $TRIMMED_R2"
echo -e "\nBismark alignment starts here\n"

## Run bismark alignment on paired-end trimmed fastqs (read_1 & read_2) using bowtie-2:
$BISMARK_PATH/bismark --bowtie2 -p $CORE_NUM --bam --temp_dir $TEMP_DIR --path_to_bowtie $BOWTIE_PATH -o $OUTPUT_DIR $GENOME_PATH -1 $TRIMMED_R1 -2 $TRIMMED_R2

### Run lambda genome alignment for QC on paired-end trimmed fastqs (read_1 & read_2) using bowtie-2:
$BISMARK_PATH/bismark --bowtie2 -p $CORE_NUM --bam --temp_dir $TEMP_DIR --path_to_bowtie $BOWTIE_PATH -o $LAMBDA_OUTPUT_DIR $LAMBDA_GENOME_PATH -1 $TRIMMED_R1 -2 $TRIMMED_R2
