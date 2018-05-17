#!/bin/bash

### Instruction: This script calls on the sort_for_coverage.sh script to do sorting for the calculation of the coverage file.

RUN_PATH=`pwd`

for LIB in ${LIB_LIST}; do
	export JOB_NAME="COVERAGE metrics of $LIB"
	bsub $BSUB_MEM_OPTIONS -J "$JOB_NAME" -o $OUTPUT_DIR/${LIB}_sort_coverage_run.out $RUN_PATH/sort_for_coverage.sh $LIB
done
#bjobs -u all -w |grep schhetri > $JOB_NUMBER_LOG
